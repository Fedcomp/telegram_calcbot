module Telegram
  module ConfiguredTelegramClient
    extend ActiveSupport::Concern
    include ConfiguredHttpClient

    included do
      def telegram_client
        Telegram::Client.new(ENV["BOT_TOKEN"], http_client)
      end
    end
  end
end
