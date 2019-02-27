module AresMUSH
  module L5R
    class L5rRollResults
      attr_accessor :result, :input

      def initialize(input, result)
        self.result = result
        self.input = input
      end

      def total
        total = self.result[:result_array].last(self.result[:keep]).inject(0, :+)
        total += self.result[:modifier]
        return total
      end

      def modifier
        self.result[:modifier]
      end

      def keep
        self.result[:keep]
      end

      def print_dice
        self.result[:result_array].join (" ")
      end

      def pretty_input
        if (input =~ /\+/)
          pieces = input.split("+").map { |p| p.strip }
          pieces.map { |p| p.titlecase }.join(" + ")
        elsif (input !~ /\d+k\d+/ && input !~ /\+/)
          self.input.titlecase
        elsif (input =~ /\d+k\d+/)
          self.input
        end
      end
    end
  end
end
