module SurenotifyRails
  class Deliverer

    attr_accessor :settings

    def initialize(settings)
      self.settings = settings
    end

    def domain
      self.settings[:domain]
    end

    def api_key
      self.settings[:api_key]
    end

    def verify_ssl
      #default value = true
      self.settings[:verify_ssl] != false
    end

    def deliver!(rails_message)
      response = surenotify_client.send_message build_surenotify_message_for(rails_message)
      if response.code == 200
        surenotify_message_id = JSON.parse(response.to_str)["id"]
        rails_message.message_id = surenotify_message_id
      end
      response
    end

    private

    def build_surenotify_message_for(rails_message)
      surenotify_message = build_basic_surenotify_message_for rails_message
      transform_surenotify_attributes_from_rails rails_message, surenotify_message
      remove_empty_values surenotify_message

      surenotify_message
    end

    def transform_surenotify_attributes_from_rails(rails_message, surenotify_message)
      transform_reply_to rails_message, surenotify_message if rails_message.reply_to
      transform_surenotify_variables rails_message, surenotify_message
      transform_surenotify_options rails_message, surenotify_message
      transform_surenotify_recipient_variables rails_message, surenotify_message
      transform_custom_headers rails_message, surenotify_message
    end

    def build_basic_surenotify_message_for(rails_message)
      surenotify_message = {
       fromName: rails_message[:from].addrs.first.name,
       fromAddress: rails_message[:from].addrs.first.address,
       recipients: formatted_receivers(rails_message[:to]),
       subject: rails_message.subject,
       content: extract_html(rails_message)
      }

      [:cc, :bcc].each do |key|
        surenotify_message[key] = rails_message[key].formatted if rails_message[key]
      end

      return surenotify_message if rails_message.attachments.empty?

      # RestClient requires attachments to be in file format, use a temp directory and the decoded attachment
      surenotify_message[:attachment] = []
      surenotify_message[:inline] = []
      rails_message.attachments.each do |attachment|
        # then add as a file object
        if attachment.inline?
          surenotify_message[:inline] << surenotifyRails::Attachment.new(attachment, encoding: 'ascii-8bit', inline: true)
        else
          surenotify_message[:attachment] << surenotifyRails::Attachment.new(attachment, encoding: 'ascii-8bit')
        end
      end

      return surenotify_message
    end

    def transform_reply_to(rails_message, surenotify_message)
      surenotify_message['h:Reply-To'] = rails_message[:reply_to].formatted.first
    end

    # @see http://stackoverflow.com/questions/4868205/rails-mail-getting-the-body-as-plain-text
    def extract_html(rails_message)
      if rails_message.html_part
        rails_message.html_part.body.decoded
      else
        rails_message.content_type =~ /text\/html/ ? rails_message.body.decoded : nil
      end
    end

    def extract_text(rails_message)
      if rails_message.multipart?
        rails_message.text_part ? rails_message.text_part.body.decoded : nil
      else
        rails_message.content_type =~ /text\/plain/ ? rails_message.body.decoded : nil
      end
    end

    def transform_surenotify_variables(rails_message, surenotify_message)
      rails_message.surenotify_variables.try(:each) do |name, value|
        surenotify_message["v:#{name}"] = value
      end
    end

    def transform_surenotify_options(rails_message, surenotify_message)
      rails_message.surenotify_options.try(:each) do |name, value|
        surenotify_message["o:#{name}"] = value
      end
    end

    def transform_custom_headers(rails_message, surenotify_message)
      rails_message.surenotify_headers.try(:each) do |name, value|
        surenotify_message["h:#{name}"] = value
      end
    end

    def transform_surenotify_recipient_variables(rails_message, surenotify_message)
      surenotify_message['recipient-variables'] = rails_message.surenotify_recipient_variables.to_json if rails_message.surenotify_recipient_variables
    end

    def remove_empty_values(surenotify_message)
      surenotify_message.delete_if { |key, value| value.nil? or
                                               value.respond_to?(:empty?) && value.empty? }
    end

    def surenotify_client
      @surenotify_client ||= Client.new(api_key, domain, verify_ssl)
    end

    def formatted_receivers(receivers)
      receivers.addrs.map { |r| { address: r.address } }
    end
  end
end

ActionMailer::Base.add_delivery_method :surenotify, SurenotifyRails::Deliverer
