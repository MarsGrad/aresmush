module AresMUSH
  module L5R
    class RollCmd
      include CommandHandler

      attr_accessor :roll_str, :difficulty

      def parse_args
        return if !cmd.args
        self.roll_str = trim_arg(cmd.args.before("vs"))
        self.difficulty = integer_arg(cmd.args.after("vs"))
      end

      def required_args
        [ self.roll_str ]
      end

      def check_difficulty
        return nil if self.difficulty.blank?
        return t('l5r.invalid_difficulty') if self.difficulty == 0
        return nil
      end

      def handle
        results = L5R.roll_ability(enactor, self.roll_str)

        if (!results)
          client.emit_failure t('l5r.invalid_roll')
          return
        end

        message = L5R.get_success_message(enactor_name, results, self.difficulty)
        Rooms.emit_ooc_to_room enactor_room, message
      end
    end
  end
end
