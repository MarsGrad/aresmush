module AresMUSH
  module L5R
    class KihoAddCmd
      include CommandHandler

      attr_accessor :target_name, :kiho_name

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.target_name = args.arg1
        self.kiho_name = args.arg2
      end

      def required_args
        [self.target_name, self.kiho_name]
      end

      def check_can_set
        return nil if L5R.can_manage_abilities?(enactor)
        return t('dispatcher.not_allowed')
      end

      def handle
        ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|

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
