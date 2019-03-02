module AresMUSH
  module L5R
    class ADSetCmd
      include CommandHandler

      attr_accessor :target_name, :affinity, :deficiency

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_arg3)
        self.target_name = titlecase_arg(args.arg1)
        self.affinity = titlecase_arg(args.arg2)
        self.deficiency = titlecase_arg(args.arg3)
      end

      def required_args
        [self.target_name, self.affinity, self.deficiency]
      end

      def check_can_set
        return nil if L5R.can_manage_abilities?(enactor)
        return t('dispatcher.not_allowed')
      end

      def handle
        ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|

          model.update(l5r_affinity: self.affinity)
          model.update(l5r_deficiency: self.deficiency)
          client.emit_success t('l5r.affinity_deficiency_set')
        end
      end
    end
  end
end
