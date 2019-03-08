module AresMUSH
  module L5R
    class WoundsHealCmd
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

      def check_can_set
        return nil if self.target_name == enactor_name
        return nil if L5R.can_manage_abilities(enactor)
        return t('dispatcher.not_allowed')
      end

      def handle
        ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
          new_total = model.l5r_current_wounds - self.amount
          if (new_total < L5R.calc_l5r_max_wounds(model))
            client.emit_failure t('l5r.pool_minimum')
            return
          end

          model.update(l5r_current_wounds: new_total)
          Global.logger.debug "L5R: #{enactor_name} has removed #{self.amount} wounds from #{self.target_name}."
          status = L5R.calc_l5r_wound_status(model)
          Rooms.emit_ooc_to_room(self.target_name, t('l5r.wounds_healed', :actor => enactor_name, :character => self.target_name, :amount => amount, :status => status))
        end
      end
    end
  end
end
