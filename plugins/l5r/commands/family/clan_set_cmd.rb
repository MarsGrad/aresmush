module AresMUSH
  module L5R
    class ClanSetCmd
      include CommandHandler

      attr_accessor :clan_name

      def parse_args
        self.clan_name = downcase_arg(cmd.args)
      end

      def required_args
        [self.clan_name]
      end

      def check_valid_clan
        return t('l5r.invalid_clan') if !L5R.is_valid_clan?(self.clan_name)
        return nil
      end

      def check_is_approved
        return nil if !enactor.is_approved?
        return t('l5r.already_approved')
      end

      def check_chargen_locked
        return nil if L5R.can_manage_abilities?(enactor)
        Chargen.check_chargen_locked(enactor)
      end

      def handle
        sheet_type = model.l5r_sheet_type
        if sheet_type != "bonge" || sheet_type != "geisha"
          client.emit_failure t('l5r.invalid_sheet_type')
          return
        end
        
        current_clan = model.l5r_clan
        if (current_clan)
          client.emit_failure t('l5r.remove_clan_first')
          return
        end

        clan_config = L5R.find_clan_config(self.clan_name)

        name = clan_config['name'].downcase
        trait_bonus = clan_config['trait_bonus']
        skills = clan_config['skills']

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

        current_insight = L5R.calc_l5r_insight(model)
        model.update(l5r_current_insight_rank: current_insight)

        model.update(l5r_clan: name)
        client.emit_success t('l5r.clan_set', :clan => name.titlecase)
      end
    end
  end
end
