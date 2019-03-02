module AresMUSH
  module L5R
    class TechAddCmd
      include CommandHandler

      attr_accessor :target_name, :tech_name

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.target_name = titlecase_arg(args.arg1)
        self.tech_name = titlecase_arg(args.arg2)
      end

      def required_args
        [self.target_name, self.tech_name]
      end

      def check_can_set
        return nil if L5R.can_manage_abilities?(enactor)
        return t('dispatcher.not_allowed')
      end

      def handle
        ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|

          tech_config = L5R.find_tech_config(self.tech_name)
          if (!tech_config)
            client.emit_failure t('l5r.invalid_ability_name')
            return
          end

          rank = tech_config['rank']
          school = tech_config['school']

          set_school = L5R.find_school(model, school)
          if (!set_school)
            client.emit_failure t('l5r.school_mismatch')
            return
          end

          tech = L5R.find_tech(model, self.tech_name)
          if (tech)
            client.emit_failure t('l5r.already_have_tech')
            return
          end

          L5rTechnique.create(name: self.tech_name, rank: rank, character: model)
          client.emit_success t('l5r.tech_added')
        end
      end
    end
  end
end
