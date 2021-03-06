module AresMUSH
  module L5R
    class SchoolSetCmd
      include CommandHandler

      attr_accessor :target_name, :school_name

      def parse_args
        self.target_name = enactor_name
        self.school_name = titlecase_arg(cmd.args)
      end

      def required_args
        [self.target_name, self.school_name]
      end

      def check_valid_school
        return t('l5r.invalid_school') if !L5R.is_valid_school?(self.school_name)
        return nil
      end

      def check_chargen_locked
        return nil if L5R.can_manage_abilities?(enactor)
        Chargen.check_chargen_locked(enactor)
      end

      def check_is_approved
        return nil if !enactor.is_approved? || L5R.can_manage_abilities?(enactor)
        return t('l5r.already_approved')
      end

      def handle
        ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
          current_school = model.l5r_schools.any?
          if (current_school)
            client.emit_failure t('l5r.remove_school_first')
            return
          end

          sheet_type = model.l5r_sheet_type
          if (!sheet_type)
            client.emit_failure t('l5r.must_set_sheet')
            return
          elsif sheet_type == "bonge" || sheet_type == "geisha"
            client.emit_failure t('l5r.invalid_sheet_type')
            return
          end

          school_config = L5R.find_school_config(self.school_name)

          school_name = school_config['name'].downcase
          clan = school_config['clan'].downcase
          trait_bonus = school_config['trait_bonus']
          skills = school_config['skills']
          skill_choice = school_config['skill_choice']
          spell_choice = school_config['spell_choice']
          shugenja = school_config['shugenja']
          affinity = school_config['affinity']
          deficiency = school_config['deficiency']
          aff_def_choice = school_config['aff_def_choice']
          honor = school_config['honor']
          first_tech = school_config['starting_technique']
          kiho_num = school_config['kiho_num']

          model.update(l5r_honor: honor)

          school = L5R.find_school(model, self.school_name)
          if (school)
            client.emit_failure t('l5r.already_have_school')
            return
          end

          current_clan = model.l5r_clan
          if (!current_clan && model.l5r_family != "None")
            client.emit_failure t('l5r.set_family_first')
            return
          elsif clan == "monk" && model.l5r_clan != "monk"
            client.emit_failure t('l5r.not_monk')
            return
          elsif (current_clan.downcase != clan && model.l5r_family != "None")
            client.emit_failure t('l5r.wrong_clan', :clan => current_clan.titlecase)
          elsif current_clan.downcase != clan && model.l5r_family == "None"
            client.emit_failure t('l5r.ronin_wrong_clan')
            return
          end

          if (shugenja == true)
            model.update(l5r_is_shugenja: true)
            if (aff_def_choice)
              client.emit_ooc t('l5r.aff_def_choice')
              model.update(l5r_affinity: affinity)
              model.update(l5r_deficiency: deficiency)
            else
              model.update(l5r_affinity: affinity)
              model.update(l5r_deficiency: deficiency)
            end
            L5rSpell.create(name: "Commune", ring: "All", mastery: 1, character: model)
            L5rSpell.create(name: "Summon", ring: "All", mastery: 1, character: model)
            L5rSpell.create(name: "Sense", ring: "All", mastery: 1, character: model)
          elsif (shugenja == false)
            model.update(l5r_is_shugenja: false)
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

          if school_name == "togashi tattooed order"
            model.update(l5r_void_ring: model.l5r_void_ring + 1)
          else
            trait = L5R.find_trait(model, trait_bonus)
            trait.update(rank: trait.rank + 1)
          end

          current_insight = L5R.calc_l5r_insight(model)
          model.update(l5r_current_insight_rank: current_insight)

          model.update(l5r_current_school: school_name)
          L5rTechnique.create(name: first_tech, rank: 1, school: school_name, character: model)
          L5rSchool.create(name: school_name.titlecase, rank: 1, character: model)
          client.emit_success t('l5r.school_set', :school => school_name.titlecase)
          client.emit_success t('l5r.school_skill_choice', :skill_choice => skill_choice)
          if spell_choice
            client.emit_success t('l5r.school_spell_choice', :spell_choice => spell_choice)
          end
          if kiho_num
            client.emit_success t('l5r.school_kiho_num', :kiho_num => kiho_num)
          end
        end
      end
    end
  end
end
