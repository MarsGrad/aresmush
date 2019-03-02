module AresMUSH
  module L5R
    class SchoolRemCmd
      include CommandHandler

      attr_accessor :target_name, :school_name

      def parse_args
        if(cmd.args =~ /\=/)
          args = cmd.parse_args(ArgParse.arg1_equals_arg2)
          self.target_name = downcase_arg(args.arg1)
          self.school_name = downcase_arg(args.arg2)
        else
          self.target_name = enactor_name
          self.school_name = downcase_arg(cmd.args)
        end
      end

      def required_args
        [self.target_name, self.school_name]
      end

      def check_can_rem
        return nil if enactor_name == self.target_name
        return nil if L5R.can_manage_abilities?(enactor)
        return t('dispatcher.not_allowed')
      end

      def check_chargen_locked
        return nil if L5R.can_manage_abilities?(enactor)
        Chargen.check_chargen_locked(enactor)
      end

      def check_is_approved
        return nil if !enactor.is_approved?
        return t('l5r.already_approved')
      end

      def handle
        ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
          current_schools = model.l5r_schools
          if (!current_schools)
            client.emit_failure t('l5r.no_school')
            return
          end

          school_config = L5R.find_school_config(self.school_name)

          trait_bonus = school_config['trait_bonus']
          first_tech = school_config['starting_technique']
          school_skills = school_config['skills']
          skill_names = []
          emp_names = []
          school_skills.each do |s|
            skill_names << s.partition("/").first
            emp_names << s.partition("/").last
          end
          trait = L5R.find_trait(model, trait_bonus)
          school = L5R.find_school(model, self.school_name)

          if (school)
            school.delete
            trait.update(rank: trait.rank - 1)
            model.l5r_skills.each do |s|
              if skill_names.include?(s.name)
                s.update(rank: s.rank - 1)
                emp_names.each do |e|
                  s.emphases.delete(e)
                end
                if s.rank == 0
                  s.delete
                end
              end
            end
            model.l5r_techniques.each do |t|
              if t.name == first_tech
                t.delete
              end
            end


            client.emit_success t('l5r.school_removed')
            return
          else
            client.emit_failure t('l5r.school_not_found')
            return
          end
        end
      end
    end
  end
end
