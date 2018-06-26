module Telegram
  class SetWebhook < ActiveInteraction::Base
    include Telegram::ConfiguredTelegramClient

    def execute
      if webhook_current_url != webhook_url
        set_webhook

        if webhook_current_url != webhook_url
          raise "Can't set webhook url, still wrong: #{response.as_json}"
        end
      end
    end

    private

    def set_webhook
      response = telegram_client.set_webhook(url: webhook_url)
      raise "Can't register webhook #{response.as_json}" unless response.ok
    end

    def webhook_current_url
      response = telegram_client.get_webhook_info
      raise "Can't check webhook url #{response.as_json}" unless response.ok
      response.result.url
    end

    def webhook_url
      @webhook_url ||= Rails.application.routes.url_helpers.api_v1_telegram_webhook_url
    end
  end
end
