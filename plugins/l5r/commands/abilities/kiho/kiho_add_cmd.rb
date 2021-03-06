module AresMUSH
  module L5R
    class KihoAddCmd
      include CommandHandler

      attr_accessor :target_name, :kiho_name

      def parse_args
        if (cmd.args =~ /\=/)
          args = cmd.parse_args(ArgParser.arg1_equals_arg2)
          self.target_name = titlecase_arg(args.arg1)
          self.kiho_name = titlecase_arg(args.arg2)
        else
          self.target_name = enactor_name
          self.kiho_name = titlecase_arg(cmd.args)
        end
      end

      def required_args
        [self.target_name, self.kiho_name]
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

          sheet_type = model.l5r_sheet_type
          if (self.target_name == enactor_name && sheet_type != "monk")
            client.emit_failure t('l5r.cant_set')
            return
          end

          kiho_config = L5R.find_kiho_config(self.kiho_name)
          if (!kiho_config)
            client.emit_failure t('l5r.invalid_ability_name')
            return
          end

          name = kiho_config['name']
          ring = kiho_config['ring']
          mastery = kiho_config['mastery']
          atemi = kiho_config['atemi']
          type = kiho_config['type']

          kiho = L5R.find_kiho(model, self.kiho_name)
          if (kiho)
            client.emit_failure t('l5r.already_have_ability')
            return
          end

          L5rKiho.create(name: name, ring: ring, mastery: mastery, type: type, atemi: atemi, character: model)
          client.emit_success t('l5r.ability_added')
        end
      end
    end
  end
end
