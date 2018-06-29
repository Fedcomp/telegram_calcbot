module Telegram
  class CalculateState < ActiveInteraction::Base
    string :value
    string :modifier

    def execute
      (value.to_i + 1).to_s
    end
  end
end
