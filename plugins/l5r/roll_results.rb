module AresMUSH
  module L5R
    class L5rRollResults
      attr_accessor :roll, :input, :keep

      def initialize(input, roll, keep)
        self.roll = roll
        self.input = input
        self.keep = keep.to_i
      end

      def total
        self.roll.last(self.keep).inject(0, :+)
      end

      def print_dice
        self.roll.join (" ")
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
