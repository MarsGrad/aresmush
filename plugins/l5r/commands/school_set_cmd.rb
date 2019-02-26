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
          self.school_name = titlecase_arg(cmd.args)
        end
      end

      def required_args
        [self.target_name, self.school_name]
      end

      def check_valid_school
        return t('l5r.invalid_school') if !L5R.is_valid_school?(self.school_name)
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

          school_name = school_config['name'].downcase
          clan = school_config['clan'].downcase
          trait_bonus = school_config['trait_bonus']
          skills = school_config['skills']
          skill_choice = school_config['skill_choice']
          shugenja = school_config['shugenja']
          honor = school_config['honor']

          model.update(l5r_honor: honor)

          school = L5R.find_school(model, self.school_name)
          if (school)
            client.emit_failure t('l5r.already_have_school')
            return
          end

          current_clan = model.l5r_clan
          if (!current_clan)
            client.emit_failure t('l5r.set_family_first')
            return
          elsif current_clan != clan
            client.emit_failure t('l5r.wrong_clan', :clan => current_clan)
            return
          end

          if (shugenja == true)
            model.update(l5r_is_shugenja: true)
          end

          emp_skills = skills.select { |e| e =~ /\//}
          non_emp_skills = skills.reject { |e| e =~ /\//}

          non_emp_skills.each do |s|
            skill = L5R.find_skill(model, s)
            if (skill)
              skill.update(rank: skill.rank + 1)
            else
              L5rSkill.create(name: s, rank: 1, character: model)
            end
          end

          emp_skills.each do |s|
            skill_name = s.partition("/").first
            emp = s.partition("/").last
            skill = L5R.find_skill(model, skill_name)

            if (skill)
              skill.update(rank: skill.rank + 1)
            else
              L5rSkill.create(name: skill_name, rank: 1, character: model)
            end

            skill = L5R.find_skill(model, skill_name)
            if (skill && !skill.emphases.include?(emp))
              skill.update(emphases: skill.emphases << emp)
            end
          end

          trait = L5R.find_trait(model, trait_bonus)
          trait.update(rank: trait.rank + 1)

          L5rSchool.create(name: school_name, rank: 1, character: model)
          client.emit_success t('l5r.school_set', :school => school_name.titlecase)
        end
      end
    end
  end
end
