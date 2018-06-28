module Telegram
  class HandleUpdate < ActiveInteraction::Base
    include Telegram::ConfiguredTelegramClient

    KEYPAD = {
      inline_keyboard: [
        [
          { text: "AC", callback_data: "AC" },
          { text: "+",  callback_data: "+" },
          { text: "-",  callback_data: "-" }
        ],
        [
          { text: "7", callback_data: "7" },
          { text: "8", callback_data: "8" },
          { text: "9", callback_data: "9" }
        ],
        [
          { text: "4", callback_data: "4" },
          { text: "5", callback_data: "5" },
          { text: "6", callback_data: "6" }
        ],
        [
          { text: "1", callback_data: "1" },
          { text: "2", callback_data: "2" },
          { text: "3", callback_data: "3" }
        ],
        [
          { text: " ", callback_data: " " },
          { text: "0", callback_data: "0" },
          { text: " ", callback_data: " " }
        ]
      ]
    }.freeze

    # update_id | Integer
    # The update's unique identifier.
    # Update identifiers start from a certain positive number and increase sequentially.
    # This ID becomes especially handy if you're using Webhooks, since it allows you
    # to ignore repeated updates or to restore the correct update sequence,
    # should they get out of order.
    # If there are no new updates for at least a week,
    # then identifier of the next update will be chosen randomly instead of sequentially.
    integer :update_id

    # message  Message  Optional
    # New incoming message of any kind - text, photo, sticker, etc.
    hash :message, default: nil do
      hash(:from) { integer :id }
      hash(:chat) { integer :id }
      string :text, default: nil
    end

    # edited_message  Message  Optional.
    # New version of a message that is known to the bot and was edited

    # channel_post  Message  Optional.
    # New incoming channel post of any kind - text, photo, sticker, etc.

    # edited_channel_post  Message  Optional.
    # New version of a channel post that is known to the bot and was edited

    # inline_query  InlineQuery  Optional. New incoming inline query
    # chosen_inline_result  ChosenInlineResult  Optional.

    # The result of an inline query that was chosen by a user and sent to their
    # chat partner. Please see our documentation on the feedback collecting
    # for details on how to enable these updates for your bot.

    # callback_query  CallbackQuery  Optional. New incoming callback query

    # shipping_query  ShippingQuery  Optional. New incoming shipping query.
    # Only for invoices with flexible price

    # pre_checkout_query  PreCheckoutQuery  Optional.
    # New incoming pre-checkout query. Contains full information about checkout

    def execute
      return unless given? :message
      return reset_keypad if message.dig("text") == "/start"
    end

    private

    def reset_keypad
      response = telegram_client.send_message chat_id: message.dig("chat", "id"),
                                              text: "0",
                                              reply_markup: KEYPAD.to_json

      raise "Can't register webhook #{response.as_json}" unless response.ok
    end
  end
end
