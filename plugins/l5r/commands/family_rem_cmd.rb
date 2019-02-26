module AresMUSH
  module L5R
    class FamilyRemCmd
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
        return t('dispatcher.not allowed')
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
          current_family = model.l5r_family

          current_schools = model.l5r_schools
          if (current_schools)
            client.emit_failure t('l5r.remove_school_first')
            return
          end

          if (current_family)
            model.update(l5r_family: nil)
            model.update(l5r_clan: nil)

            L5R.set_l5r_trait(model, 'agility', 2)
            L5R.set_l5r_trait(model, 'awareness', 2)
            L5R.set_l5r_trait(model, 'intelligence', 2)
            L5R.set_l5r_trait(model, 'perception', 2)
            L5R.set_l5r_trait(model, 'reflexes', 2)
            L5R.set_l5r_trait(model, 'stamina', 2)
            L5R.set_l5r_trait(model, 'strength', 2)
            L5R.set_l5r_trait(model, 'willpower', 2)

            client.emit_success t('l5r.family_removed')
            return
          else
            client.emit_failure t('l5r.no_family')
            return
          end
        end
      end
    end
  end
end
