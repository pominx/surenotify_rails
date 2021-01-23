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
        headers: {
          x_api_key: @api_key,
          content_type: 'application/json',
          accept: 'application/json',
        }
        method: :post,
        url: surenotify_url,
        payload: options,
        verify_ssl: verify_ssl
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
