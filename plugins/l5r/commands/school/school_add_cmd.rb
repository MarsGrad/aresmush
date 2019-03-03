module AresMUSH
  module L5R
    class SchoolAddCmd
      include CommandHandler

      attr_accessor :target_name, :school_name

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.target_name = titlecase_arg(args.arg1)
        self.school_name = titlecase_arg(args.arg2)
      end

      def required_args
        [self.target_name, self.school_name]
      end

      def check_can_set
        return nil if L5R.can_manage_abilities?(enactor)
        return t('l5r.wrong_school_command')
      end

      def handle
        ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|

          school_config = L5R.find_school_config(self.school_name)
          if (!school_config)
            client.emit_failure t('l5r.invalid_school')
            return
          end

          shugenja = school_config['shugenja']

          schools = L5R.find_school(model, self.school_name)
          if (schools)
            client.emit_failure t('l5r.already_have_school')
            return
          end

          if shugenja == true
            is_shugenja = model.l5r_is_shugenja
            if is_shugenja == false
              client.emit_failure t('l5r.shugenja_mismatch')
              return
            end
          elsif shugenja == false
            is_shugenja = model.l5r_is_shugenja
            if is_shugenja == true
              client.emit_failure t('l5r.shugenja_mismatch')
              return
            end
          end

          model.update(l5r_current_school: self.school_name)
          L5rSchool.create(name: school_name, rank: 1, character: model)
          client.emit_success t('l5r.school_set', :school => school_name.titlecase)
        end
      end
    end
  end
end
