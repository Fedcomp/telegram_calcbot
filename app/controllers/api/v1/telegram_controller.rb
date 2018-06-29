module Api
  module V1
    class TelegramController < ApplicationController
      def webhook
        Telegram::HandleUpdate.run!(telegram_update_params)
      end

      private

      def telegram_update_params
        params.slice(:update_id, :message, :callback_query).to_unsafe_h
      end
    end
  end
end
