module AresMUSH
  module L5R
    class SkillRaiseCmd
      include CommandHandler

      attr_accessor :target_name, :skill_name

      def parse_args
        args = parse_args(ArgParse.arg1_equals_arg2)
        self.target_name = titlecase_arg(args.arg1)
        self.skill_name = titlecase_arg(args.arg2)
      end

      def required_args
        [self.target_name, self.skill_name]
      end

      def check_can_set
        return nil if L5R.can_manage_abilities?(enactor)
        return t('dispatcher.not_allowed')
      end

      def handle
        ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|

          skill_config = L5R.find_skill_config(self.skill_name)

          if (!skill_config)
            client.emit_failure t('l5r.invalid_skill')
            return
          end

          skill = L5R.find_skill(model, self.skill_name)
          if (skill)
            skill.update(rank: skill.rank + 1)
          else
            L5rSkill.create(name: self.skill_name, rank: 1, character: model)
          end

          client.emit_success t('l5r.skill_raised', :skill => self.skill_name)

          model.update(l5r_old_insight_rank: model.l5r_current_insight_rank)
          model.update(l5r_current_insight_rank: L5R.calc_l5r_insight(model))

          if model.l5r_old_insight_rank != model.l5r_current_insight_rank
            current_school = model.l5r_current_school
            school = L5R.find_school(model, current_school)
            school.update(rank: school.rank + 1)
            client.emit_success t('l5r.insight_rank_up', :character => model)
          end
        end
      end
    end
  end
end
