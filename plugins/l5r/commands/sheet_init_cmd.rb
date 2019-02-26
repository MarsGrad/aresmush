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

        agi = L5R.find_trait(enactor, 'agility')
        if (agi)
          agi.update(rank: 2)
        else
          L5rTrait.create(name: 'agility', rank: 2, character: enactor)
        end

        awa = L5R.find_trait(enactor, 'awareness')
        if (awa)
          awa.update(rank: 2)
        else
          L5rTrait.create(name: 'awareness', rank: 2, character: enactor)
        end

        int = L5R.find_trait(enactor, 'intelligence')
        if (int)
          int.update(rank: 2)
        else
          L5rTrait.create(name: 'intelligence', rank: 2, character: enactor)
        end

        per = L5R.find_trait(enactor, 'perception')
        if (per)
          per.update(rank: 2)
        else
          L5rTrait.create(name: 'perception', rank: 2, character: enactor)
        end

        ref = L5R.find_trait(enactor, 'reflexes')
        if (ref)
          ref.update(rank: 2)
        else
          L5rTrait.create(name: 'reflexes', rank: 2, character: enactor)
        end

        stam = L5R.find_trait(enactor, 'stamina')
        if (stam)
          stam.update(rank: 2)
        else
          L5rTrait.create(name: 'stamina', rank: 2, character: enactor)
        end

        str = L5R.find_trait(enactor, 'strength')
        if (str)
          str.update(rank: 2)
        else
          L5rTrait.create(name: 'strength', rank: 2, character: enactor)
        end

        will = L5R.find_trait(enactor, 'willpower')
        if (will)
          will.update(rank: 2)
        else
          L5rTrait.create(name: 'willpower', rank: 2, character: enactor)
        end

        enactor.update(l5r_void_ring: 2)

        client.emit_success t('l5r.init_success')
      end
    end
  end
end
