module Api
  module V1
    class TelegramController < ApplicationController
      def webhook
        render json: {}
      end
    end
  end
end
