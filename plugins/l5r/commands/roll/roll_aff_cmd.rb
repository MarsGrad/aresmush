module AresMUSH
  module L5R
    class RollAffCmd
      include CommandHandler

      attr_accessor :roll_str, :difficulty, :modifier

      def parse_args
        return if !cmd.args
        if cmd.args =~ /\//
          args = cmd.parse_args(ArgParser.arg1_slash_arg2_equals_arg3)
          self.roll_str = trim_arg(args.arg1)
          self.modifier = integer_arg(args.arg2)
          self.difficulty = integer_arg(args.arg3)
        else
          args = cmd.parse_args(ArgParser.arg1_equals_arg2)
          self.roll_str = trim_arg(args.arg1)
          self.modifier = 0
          self.difficulty = integer_arg(args.arg2)
        end
      end

      def required_args
        [ self.roll_str ]
      end

      def check_difficulty
        return nil if self.difficulty.blank?
        return t('l5r.invalid_difficulty') if self.difficulty < 0
        return nil
      end

      def handle
        results = L5R.roll_aff_ability(enactor, self.roll_str, self.modifier)

        if (!results)
          client.emit_failure t('l5r.invalid_roll')
          return
        end

        message = L5R.get_aff_success_message(enactor_name, results, self.difficulty)
        Rooms.emit_ooc_to_room enactor_room, message
      end
    end
  end
end
