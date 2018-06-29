require "rails_helper"

RSpec.describe Telegram::HandleUpdate do
  let(:telegram_client) { double }

  before do
    # Quick and dirty
    allow_any_instance_of(described_class)
      .to receive(:telegram_client).and_return(telegram_client)
  end

  describe "/start" do
    let(:chat_id) { 77_550_740 }

    let(:params) do
      {
        "update_id" => 71_058_333,
        "message" =>
        {
          "message_id" => 12,
          "from" => {
            "id" => chat_id, "is_bot" => false, "first_name" => "Alex",
            "last_name" => "Ilizarov", "username" => "Fedcomp", "language_code" => "en-US"
          },
          "chat" => {
            "id" => chat_id, "first_name" => "Alex", "last_name" => "Ilizarov",
            "username" => "Fedcomp", "type" => "private"
          },
          "date" => 1_530_583_620,
          "text" => "/start",
          "entities" => [{ "offset" => 0, "length" => 6, "type" => "bot_command" }]
        }
      }
    end

    let(:send_message_stub) do
      Hashie::Mash.new(
        "ok" => true,
        "result" =>
        {
          "message_id" => 74,
          "from" => {
            "id" => 608_355_882, "is_bot" => true, "first_name" => "calcbot",
            "username" => "SimpleCalcPadBot"
          },
          "chat" => {
            "id" => 77_550_740, "first_name" => "Alex", "last_name" => "Ilizarov",
            "username" => "Fedcomp", "type" => "private"
          }, "date" => 1_530_599_578, "text" => "0"
        }
      )
    end

    it "send keypad" do
      expect(telegram_client).to receive(:send_message)
        .with(chat_id: chat_id, text: "0", reply_markup: described_class::KEYPAD.to_json)
        .and_return(send_message_stub)

      described_class.run(params)
    end
  end

  describe "calculate callback" do
    let(:chat_id) { 77_550_740 }
    let(:message_id) { 79 }
    let(:params) do
      {
        "update_id" => 71_058_360,
        "callback_query" =>
        {
          "id" => "333077894564504924",
          "from" => {
            "id" => 77_550_740, "is_bot" => false, "first_name" => "Alex",
            "last_name" => "Ilizarov", "username" => "Fedcomp", "language_code" => "en-US"
          },
          "message" =>
          {
            "message_id" => message_id,
            "from" => {
              "id" => 608_355_882, "is_bot" => true, "first_name" => "calcbot",
              "username" => "SimpleCalcPadBot"
            },
            "chat" => {
              "id" => chat_id, "first_name" => "Alex", "last_name" => "Ilizarov",
              "username" => "Fedcomp", "type" => "private"
            },
            "date" => 1_530_605_388,
            "text" => "0"
          },
          "chat_instance" => "-5960977595900654212",
          "data" => "7"
        }
      }
    end

    let(:send_message_stub) do
      Hashie::Mash.new(
        "ok" => true,
        "result" =>
        {
          "message_id" => 74,
          "from" => {
            "id" => 608_355_882, "is_bot" => true, "first_name" => "calcbot",
            "username" => "SimpleCalcPadBot"
          },
          "chat" => {
            "id" => 77_550_740, "first_name" => "Alex", "last_name" => "Ilizarov",
            "username" => "Fedcomp", "type" => "private"
          }, "date" => 1_530_599_578, "text" => "0"
        }
      )
    end

    it "call calc and modify calcpad message" do
      expect(Telegram::CalculateState).to receive(:run!).and_return("2")
      expect(telegram_client).to receive(:edit_message_text)
        .with(chat_id: chat_id, message_id: message_id, text: "2", reply_markup: described_class::KEYPAD.to_json)
        .and_return(send_message_stub)

      described_class.run(params)
    end
  end
end
