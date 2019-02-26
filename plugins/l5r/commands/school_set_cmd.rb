module AresMUSH
  module L5R
    class SchoolSetCmd
      include CommandHandler

      attr_accessor :target_name, :school_name

      def parse_args
        # Admin version
        if(cmd.args =~ /\=/)
          args = cmd.parse_args(ArgParse.arg1_equals_arg2)
          self.target_name = titlecase_arg(args.arg1)
          self.school_name = titlecase_arg(args.arg2)
        else
          self.target_name = enactor_name
          self.family_name = titlecase_arg(cmd.args)
        end
      end

      def required_args
        [self.target_name, self.school_name]
      end

      def check_valid_school
        return t('l5r.invalid_school') if L5R.is_valid_school?(self.school_name)
        return nil
      end

      def check_can_set
        return nil if enactor_name == self.target_name
        return nil if L5R.can_manage_abilities?(enactor)
        return t('dispatcher.not_allowed')
      end

      def check_chargen_locked
        return nil if L5R.can_manage_abilities?(enactor)
        Chargen.check_chargen_locked(enactor)
      end

      def handle
        ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|

          school_config = L5R.find_school_config(self.school_name)

          school = school_config['name'].downcase
          clan = school_config['clan'].downcase
          trait_bonus = school_config['clan']
        end
      end
    end
  end
end
