module AresMUSH
  module L5R
    class ClanRemCmd
      include CommandHandler

      attr_accessor :target_name

      def parse_args
        # Admin version
        if(cmd.args)
          self.target_name = trim_arg(cmd.args)
        else
          self.target_name = enactor_name
        end
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

      def handle
        ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|

          sheet_type = model.l5r_sheet_type
          if sheet_type != "bonge" && sheet_type != "geisha"
            client.emit_failure t('l5r.invalid_sheet_type')
            return
          end

          if model.is_approved?
            client.emit_failure t('l5r.already_approved')
            return
          end

          current_clan = model.l5r_clan

          if (current_clan)
            model.update(l5r_clan: nil)

            L5R.set_l5r_trait(model, 'agility', 2)
            L5R.set_l5r_trait(model, 'awareness', 2)
            L5R.set_l5r_trait(model, 'intelligence', 2)
            L5R.set_l5r_trait(model, 'perception', 2)
            L5R.set_l5r_trait(model, 'reflexes', 2)
            L5R.set_l5r_trait(model, 'stamina', 2)
            L5R.set_l5r_trait(model, 'strength', 2)
            L5R.set_l5r_trait(model, 'willpower', 2)

            model.l5r_skills.each { |s| s.delete }

            client.emit_success t('l5r.clan_removed')
            return
          else
            client.emit_failure t('l5r.no_clan')
            return
          end
        end
      end
    end
  end
end
