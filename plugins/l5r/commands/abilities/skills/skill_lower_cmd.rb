module AresMUSH
  module L5R
    class SkillRaiseCmd
      include CommandHandler

      attr_accessor :target_name, :skill_name

      def parse_args
        if (cmd.args =~ /\=/)
          args = cmd.parse_args(ArgParser.arg1_equals_arg2)
          self.target_name = titlecase_arg(args.arg1)
          self.skill_name = titlecase_arg(args.arg2)
        else
          self.target_name = enactor_name
          self.skill_name = titlecase_arg(cmd.args)
        end
      end

      def required_args
        [self.target_name, self.skill_name]
      end

      def check_can_set
        return nil if self.target_name == enactor_name
        return nil if L5R.can_manage_abilities?(enactor)
        return t('dispatcher.not_allowed')
      end

      def check_chargen_locked
        return nil if L5R.can_manage_abilities?(enactor)
        Chargen.check_chargen_locked(enactor)
      end

      def handle
        ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|

          valid = L5R.is_valid_l5r_skill_name?(self.skill_name)
          if (valid == false)
            client.emit_failure t('l5r.invalid_skill')
            return
          end

          skill = L5R.find_skill(model, self.skill_name)
          if (skill)
            skill.update(rank: skill.rank - 1)
            if skill.rank == 0
              skill.delete
            end
          else
            client.emit_failure t('l5r.no_skill')
            return
          end

          client.emit_success t('l5r.skill_lowered', :skill => self.skill_name)

          model.update(l5r_old_insight_rank: model.l5r_current_insight_rank)
          model.update(l5r_current_insight_rank: L5R.calc_l5r_insight(model))

          old = model.l5r_old_insight_rank
          current = model.l5r_current_insight_rank

          name = model.name

          if "#{old}" == "#{current}"
            return
          elsif "#{old}" > "#{current}"
            current_school = model.l5r_current_school
            school = L5R.find_school(model, current_school)
            school.update(rank: school.rank - 1)
            model.update(l5r_old_insight_rank: model.l5r_current_insight_rank)
            client.emit_success t('l5r.insight_rank_down', :character => name)
          end
        end
      end
    end
  end
end
