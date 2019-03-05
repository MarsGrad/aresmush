module AresMUSH
  module L5R
    class KataAddCmd
      include CommandHandler

      attr_accessor :target_name, :kata_name

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.target_name = titlecase_arg(args.arg1)
        self.kata_name = titlecase_arg(args.arg2)
      end

      def required_args
        [self.target_name, self.kata_name]
      end

      def check_can_set
        return nil if L5R.can_manage_abilities?(enactor)
        return t('dispatcher.not_allowed')
      end

      def handle
        ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|

          kata_config = L5R.find_kata_config(self.kata_name)
          if (!kata_config)
            client.emit_failure t('l5r.invalid_ability_name')
            return
          end

          name = kata_config['name']
          mastery = kata_config['mastery']
          ring = kata_config['ring']
          schools = kata_config['schools']

          set_schools = model.l5r_schools
          set_schools = set_schools.map { |s| s.name }

          if !schools.include?("Any")
            comparison = schools.map { |s| set_schools.include?(s) }
            if !comparison.include?(true)
              client.emit_failure t('l5r.school_mismatch')
              return
            end
          end

          kata = L5R.find_kata(model, self.kata_name)
          if (kata)
            client.emit_failure t('l5r.already_have_ability')
            return
          end

          L5rKata.create(name: name.titlecase, mastery: mastery, ring: ring, character: model)
          client.emit_success t('l5r.ability_added')
        end
      end
    end
  end
end
