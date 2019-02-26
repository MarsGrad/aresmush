module AresMUSH
  module L5R
    class FamilySetCmd
      include CommandHandler

      attr_accessor :target_name, :family_name

      def parse_args
        # Admin version
        if (cmd.args =~ /\=/)
          args = cmd.parse_args(ArgParse.arg1_equals_arg2)
          self.target_name = titlecase_arg(args.arg1)
          self.family_name = titlecase_arg(args.arg2)
        else
          self.target_name = enactor_name
          self.family_name = titlecase_arg(cmd.args)
      end

      def required_args
        [self.family_name, self.target_name]
      end

      def check_valid_family
        return t('l5r.invalid_family') if !L5R.is_valid_family?(self.family_name)
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

            family_config = L5R.find_family_config(self.family_name)

            family = family_config['name'].downcase
            clan = family_config['clan'].downcase
            trait_bonus = family_config['trait_bonus']

            model.update(l5r_family: family)
            model.update(l5r_clan: clan)

            current_family = model.l5r_family

            if (current_family)
              current_family_config = L5R.find_family_config(current_family)
              current_trait_bonus = current_family_config['trait_bonus']
              current_trait = L5R.find_trait(model, current_trait_bonus)
              current_trait.update(rank: current_trait.rank - 1)
              client.emit "Removing previous trait bonus success"
            end

            trait = L5R.find_trait(model, trait_bonus)
            if (trait)
              trait.update(rank: trait.rank + 1)
              client.emit_success t('l5r.family_added', :family => self.family_name, :clan => clan.titlecase)
            else
              client.emit_failure t('l5r.must_init_first')
            end
          end
        end
      end
    end
  end
end
