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
        return t('l5r.invalid_family') if !L5R.is_valid_family?(self.family_name) && self.family_name != "None"
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
            current_family = model.l5r_family
            if (current_family)
              client.emit_failure t('l5r.remove_family_first')
              return
            end

            if model.is_approved?
              client.emit_failure t('l5r.already_approved')
              return
            end

            sheet_type = model.l5r_sheet_type
            if (!sheet_type)
              client.emit_failure t('l5r.must_set_sheet')
              return
            elsif sheet_type != "ronin" && sheet_type != "samurai"
              client.emit_failure t('l5r.invalid_sheet_type')
              return
            elsif self.family_name == "None" && sheet_type == "ronin"
              model.update(l5r_family: "None")
              model.update(l5r_clan: "None")
              client.emit_success t('l5r.family_none_added')
              return
            elsif self.family_name == "None" && sheet_type != "ronin"
              client.emit_failure t('l5r.invalid_family')
              return
            end

            family_config = L5R.find_family_config(self.family_name)

            family = family_config['name'].downcase
            clan = family_config['clan'].downcase
            trait_bonus = family_config['trait_bonus']

            model.update(l5r_family: family)
            model.update(l5r_clan: clan)

            Demographics.set_group(model, "clan", clan.titlecase)

            trait = L5R.find_trait(model, trait_bonus)
            if (trait)
              trait.update(rank: 3)
              client.emit_success t('l5r.family_added', :family => family.titlecase, :clan => clan.titlecase)
            else
              client.emit_failure t('l5r.must_init_first')
            end
          end
        end
      end
    end
  end
end
