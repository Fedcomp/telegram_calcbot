module Telegram
  class CalculateState < ActiveInteraction::Base
    string :value
    string :modifier

    LINE_REGEX = /(?<current_value>[+-]?\d+)(?<operator> [+-])?(?<apply_value> \d+)?/

    validates :value, format: { with: LINE_REGEX, message: "unexpected expression" }

    def execute
      case modifier
      when "AC"
        state.merge!(
          current_value: 0,
          apply_value: nil,
          operator: nil
        )
      when "+"
        if state[:operator] == "+" # do calc
          state[:current_value] += state[:apply_value]
          state[:apply_value] = nil
          state[:operator] = nil
        else # set plus
          state[:operator] = "+"
        end
      when "-"
        if state[:operator] == "-" # do calc
          state[:current_value] -= state[:apply_value]
          state[:apply_value] = nil
          state[:operator] = nil
        else # set plus
          state[:operator] = "-"
        end
      when "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"
        if state[:operator]
          unless state[:apply_value] == "0"
            state[:apply_value] = "#{state[:apply_value]}#{modifier}".to_i
          end
        else
          unless state[:apply_value] == "0"
            state[:current_value] = "#{state[:current_value]}#{modifier}".to_i
          end
        end
      end

      puts "new state"
      puts serialized_state.inspect
      serialized_state
    end

    private

    def state
      match = value.match(LINE_REGEX)

      @state ||= {
        current_value: match[:current_value].to_i,
        apply_value: match.try(:[], :apply_value)&.strip&.to_i,
        operator: match.try(:[], :operator)&.strip
      }
    end

    def serialized_state
      "#{state[:current_value]} #{state[:operator]} #{state[:apply_value]}".squish
    end
  end
end
