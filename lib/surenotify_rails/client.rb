require 'rest_client'


module SurenotifyRails
  class Client
    attr_reader :api_key, :domain, :verify_ssl

    def initialize(api_key, domain, verify_ssl = true)
      @api_key = api_key
      @domain = domain
      @verify_ssl = verify_ssl
    end

    def send_message(options)
      RestClient::Request.execute(
        method: :post,
        url: surenotify_url,
        payload: JSON::dump(options),
        verify_ssl: verify_ssl,
        headers: {
          content_type: 'application/json',
                accept: 'application/json',
             x_api_key: @api_key
        }
      )
    end

    def surenotify_url
      api_url + "/messages"
    end

    def api_url
      'https://mail.surenotifyapi.com/v1'
    end
  end
end
