require "rails_helper"

RSpec.describe Telegram::Client do
  let(:mocked_response) { double(success?: true, body: '{ "ok": true }') }
  let(:http_client) do
    # For debugging purposes
    # HttpClient.new timeout: 5,
    #                connecttimeout: 5,
    #                verbose: true,
    #                proxy: "tor:9050",
    #                proxytype: "socks5"
    double(post: mocked_response)
  end

  subject { described_class.new(ENV["BOT_TOKEN"], http_client) }

  it "call telegram api with args using http client and return traversable hash" do
    expect(subject.set_webhook(url: "http://example.com")&.ok).to be_truthy
  end

  context "errors" do
    let(:mocked_response) { double(success?: false, code: 400, timed_out?: false) }

    # TODO: Better error handling
    it "return error code and timeout status if request was not succesful" do
      expect(subject.get_webhook_info)
        .to eq({ok: false, http_code: 400, timeout: false}.as_json)
    end
  end
end
