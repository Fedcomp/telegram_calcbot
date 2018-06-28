require "rails_helper"

RSpec.describe Telegram::SetWebhook do
  let(:telegram_client) { double }

  before do
    # Quick and dirty
    allow_any_instance_of(described_class)
      .to receive(:telegram_client).and_return(telegram_client)
  end

  describe "fresh start with no hook registered" do
    let(:webhook_url) { Rails.application.routes.url_helpers.api_v1_telegram_webhook_url }

    let(:get_webhook_info_not_set) do
      Hashie::Mash.new(
        "ok" => true,
        "result" => {
          "url" => "",
          "has_custom_certificate" => false,
          "pending_update_count" => 0
        }
      )
    end

    let(:get_webhook_info_set) do
      Hashie::Mash.new(
        "ok" => true,
        "result" =>
        {
          "url" => webhook_url,
          "has_custom_certificate" => false,
          "pending_update_count" => 0,
          "max_connections" => 40
        }
      )
    end

    let(:set_webhook_ok) do
      Hashie::Mash.new("ok" => true, "result" => true, "description" => "Webhook was set")
    end

    it "register webhook for application" do
      expect(telegram_client)
        .to receive(:get_webhook_info)
        .and_return(get_webhook_info_not_set, get_webhook_info_set)
      expect(telegram_client)
        .to receive(:set_webhook).with(url: webhook_url).and_return(set_webhook_ok)

      described_class.run
    end
  end

  describe "start when hook already registered" do
    let(:webhook_url) { Rails.application.routes.url_helpers.api_v1_telegram_webhook_url }

    let(:get_webhook_info_set) do
      Hashie::Mash.new(
        "ok" => true,
        "result" =>
        {
          "url" => webhook_url,
          "has_custom_certificate" => false,
          "pending_update_count" => 0,
          "max_connections" => 40
        }
      )
    end

    let(:set_webhook_ok) do
      Hashie::Mash.new("ok" => true, "result" => true, "description" => "Webhook was set")
    end

    it "check webhook is already set for application" do
      expect(telegram_client)
        .to receive(:get_webhook_info).and_return(get_webhook_info_set)

      described_class.run
    end
  end
end
