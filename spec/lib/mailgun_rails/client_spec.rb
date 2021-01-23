require 'spec_helper'
require 'surenotify_rails/client'

describe SurenotifyRails::Client do
  let(:client){SurenotifyRails::Client.new(:some_api_key, :some_domain)}

  describe "#send_message" do
    it 'should make a POST rest request passing the parameters to the Surenotify end point' do
      expected_url = "https://api:some_api_key@api.surenotify.net/v3/some_domain/messages"
      RestClient::Request.stub(:execute).with({ method: :post, url: expected_url, payload: { foo: :bar }, verify_ssl: true})
      client.send_message foo: :bar
    end
  end
end
