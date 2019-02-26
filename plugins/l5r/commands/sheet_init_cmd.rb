module AresMUSH
  module L5R
    class SheetInitCmd
      include CommandHandler

      attr_accessor :confirm

      def parse_args
        self.confirm = downcase_arg(cmd.args)
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
        return client.emit_failure t('l5r.init_warning') if !self.confirm
        return client.emit_failure t('dispatcher.huh') if self.confirm != 'confirm'

        clan = enactor.l5r_clan
        if (clan)
          enactor.update(l5r_clan: nil)
        end

        family = enactor.l5r_family
        if (family)
          enactor.update(l5r_family: nil)
        end

        schools = enactor.l5r_schools
        if (schools)
          schools.each { |s| s.delete }
        end

        shugenja = enactor.l5r_is_shugenja
        if shugenja == true
          enactor.update(l5r_is_shugenja: false)
        end

        L5R.set_l5r_trait(enactor, 'agility', 2)

        L5R.set_l5r_trait(enactor, 'awareness', 2)

        L5R.set_l5r_trait(enactor, 'intelligence', 2)

        L5R.set_l5r_trait(enactor, 'perception', 2)

        L5R.set_l5r_trait(enactor, 'reflexes', 2)

        L5R.set_l5r_trait(enactor, 'stamina', 2)

        L5R.set_l5r_trait(enactor, 'strength', 2)

        L5R.set_l5r_trait(enactor, 'willpower', 2)

        enactor.update(l5r_void_ring: 2)

        client.emit_success t('l5r.init_success')
      end
    end
  end
end
