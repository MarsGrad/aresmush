module AresMUSH
  module L5R
    class SpellAddCmd
      include CommandHandler

      attr_accessor :target_name, :spell_name

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.target_name = titlecase_arg(args.arg1)
        self.spell_name = titlecase_arg(args.arg2)
      end

      def required_args
        [self.target_name, self.spell_name]
      end

      def check_can_set
        return nil if L5R.can_manage_abilities?(enactor)
        return t('dispatcher.not_allowed')
      end

      def handle
        ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|

          spell_config = L5R.find_spell_config(self.spell_name)
          if (!spell_config)
            client.emit_failure t('l5r.invalid_ability_name')
            return
          end

          mastery = spell_config['mastery']
          ring = spell_config['ring']
          name = spell_config['name']

          shugenja = model.l5r_is_shugenja
          if shugenja == false
            client.emit_failure t('l5r.not_shugenja')
            return
          end

          spell = L5R.find_spell(model, self.spell_name)
          if (spell)
            client.emit_failure t('l5r.already_have_spell')
            return
          end

          L5rSpell.create(name: name, ring: ring, mastery: mastery, character: model)
          client.emit_success t('l5r.spell_added')
        end
      end
    end
  end
end
