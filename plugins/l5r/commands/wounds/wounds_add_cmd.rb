module AresMUSH
  module L5R
    class WoundsAddCmd
      include CommandHandler

      attr_accessor :target_name, :amount

      def parse_args
        if (cmd.args =~ /\=/)
          args = cmd.parse_args(ArgParser.arg1_equals_arg2)
          self.target_name = titlecase_arg(args.arg1)
          self.amount = integer_arg(args.arg2)
        else
          self.target_name = enactor_name
          self.amount = integer_arg(cmd.args)
        end
      end

      def required_args
        [self.target_name, self.amount]
      end

      def check_can_set
        return nil if self.target_name == enactor_name
        return nil if L5R.can_manage_abilities?(enactor)
        return t('dispatcher.not_allowed')
      end

      def handle
        ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
          new_total = model.l5r_current_wounds + self.amount

          model.update(l5r_current_wounds: new_total)
          Global.logger.debug "L5R: #{enactor_name} has added #{self.amount} wounds to #{self.target_name}."
          status = L5R.calc_l5r_wound_status(model)
          Rooms.emit_ooc_to_room model.room, t('l5r.wounds_added', :actor => enactor_name, :character => self.target_name, :amount => self.amount, :status => status)
        end
      end
    end
  end
end
