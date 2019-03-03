module AresMUSH
  module L5R
    class XPAwardCmd
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

      def check_can_award
        return nil if L5R.can_manage_abilities?(enactor)
        return t('dispatcher.not_allowed')
      end

      def handle
        ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
          xp = self.xp.to_f

          L5R.award_xp(model, xp)
          Global.logger.info "#{xp} XP Awarded by #{enactor_name} to #{model.name} for #{self.reason}"
          datetime = DateTime.now.to_s
          datetime = datetime.split("T")
          date = datetime[0]
          L5rXpLog.create(date: date, log: t('l5r.xp_log', :type => "Award", :actor => enactor_name, :xp => xp, :reason => self.reason), :character => model)
          client.emit_success t('l5r.xp_awarded', :recipient => model.name, :amount => xp, :reason => self.reason)
          Login.emit_ooc_if_logged_in(model, t('l5r.xp_awarded_recipient', :awarder => enactor_name, :amount => xp, :reason => self.reason))
        end
      end
    end
  end
end
