module AresMUSH
  module L5R
    class SpellRemCmd
      include CommandHandler

      attr_accessor :target_name, :spell_name

      def parse_args
        if (cmd.args =~ /\=/)
          args = cmd.parse_args(ArgParser.arg1_equals_arg2)
          self.target_name = titlecase_arg(args.arg1)
          self.spell_name = titlecase_arg(args.arg2)
        else
          self.target_name = enactor_name
          self.spell_name = titlecase_arg(cmd.args)
        end
      end

      def required_args
        [self.target_name, self.spell_name]
      end

      def check_can_set
        return nil if L5R.can_manage_abilities?(enactor)
        return nil if self.target_name == enactor_name
        return t('dispatcher.not_allowed')
      end

      def check_chargen_locked
        return nil if L5R.can_manage_abilities?(enactor)
        Chargen.check_chargen_locked(enactor)
      end

      def handle
        ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|

          spell = L5R.find_spell(model, self.spell_name)
          if (!spell)
            client.emit_failure t('l5r.no_spell')
            return
          end

          spell.delete
          client.emit_success t('l5r.spell_removed')
        end
      end
    end
  end
end
