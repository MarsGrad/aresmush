module AresMUSH
  module L5R
    class XPSpendCmd
      include CommandHandler

      attr_accessor :target_name, :xp, :reason

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_arg3)
        self.target_name = titlecase_arg(args.arg1)
        self.xp = integer_arg(args.arg2)
        self.reason = titlecase_arg(args.arg3)
      end

      def required_args
        [self.target_name, self.xp, self.reason]
      end

      def check_can_spend
        return nil if L5R.can_manage_abilities?(enactor)
        return t('dispatcher.not_allowed')
      end

      def handle
        ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
          xp = self.xp.to_f

          L5R.spend_xp(model, xp)
          Global.logger.info "#{xp} of #{model.name}'s XP spent by #{enactor_name} for: #{self.reason}"
          L5rXpLog.create(date: DateTime.now, log: t('l5r.xp_log', :type => "Spent", :actor => enactor_name, :xp => xp, :reason => self.reason), :character => model)
          client.emit_success t('l5r.xp_spent', :target => model.name, :amount => xp, :reason => self.reason)
          Login.emit_ooc_if_logged_in(model, t('l5r.xp_spent_recipient', :spender => enactor_name, :amount => xp, :reason => self.reason))
        end
      end
    end
  end
end
