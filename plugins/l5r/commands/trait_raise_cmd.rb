module AresMUSH
  module L5R
    class TraitRaiseCmd
      include CommandHandler

      attr_accessor :target_name, :trait_name

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.target_name = titlecase_arg(args.arg1)
        self.trait_name = titlecase_arg(args.arg2)
      end

      def required_args
        [self.target_name, self.trait_name]
      end

      def check_can_set
        return nil if L5R.can_manage_abilities?(enactor)
        return t('dispatcher.not_allowed')
      end

      def handle
        ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|

          trait = L5R.find_trait(model, self.trait_name)
          if (trait)
            trait.update(rank: trait.rank + 1)
            client.emit_success t('l5r.trait_raised', :trait => self.trait_name)
          else
            client.emit_failure t('l5r.must_init_first')
          end

          model.update(l5r_old_insight_rank: model.l5r_current_insight_rank)
          model.update(l5r_current_insight_rank: L5R.calc_l5r_insight(model))

          old = model.l5r_old_insight_rank
          current = model.l5r_current_insight_rank

          name = model.name

          if "#{old}" == "#{current}"
            return
          else
            current_school = model.l5r_current_school
            school = L5R.find_school(model, current_school)
            school.update(rank: school.rank + 1)
            client.emit_success t('l5r.insight_rank_up', :character => name)
          end
        end
      end
    end
  end
end
