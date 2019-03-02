module AresMUSH
  module L5R
    class SheetSetCmd
      include CommandHandler

      attr_accessor :sheet_type

      def parse_args
        self.sheet_type = downcase_arg(cmd.args)
      end

      def required_args
        [self.sheet_type]
      end

      def check_is_approved
        return nil if !enactor.is_approved? || L5R.can_manage_abilities?(enactor)
        return t('l5r.already_approved')
      end

      def check_chargen_locked
        return nil if L5R.can_manage_abilities?(enactor)
        Chargen.check_chargen_locked(enactor)
      end

      def check_sheet_set
        return nil if !enactor.l5r_sheet_type
        return t('l5r.sheet_already_set')
      end

      def handle

        sheet_type = self.sheet_type

        if sheet_type == "bonge" || sheet_type == "geisha"
          enactor.update(l5r_void_ring: 1)
          enactor.update(l5r_void_pool: 1)
          enactor.update(l5r_sheet_type: sheet_type)
          client.emit_success t('l5r.sheet_type_set', :sheet_type => sheet_type.titlecase)
        elsif sheet_type == "monk"
          enactor.update(l5r_void_ring: 3)
          enactor.update(l5r_void_pool: 3)
          enactor.update(l5r_sheet_type: sheet_type)
          client.emit_success t('l5r.sheet_type_set', :sheet_type => sheet_type.titlecase)
        elsif sheet_type == "ronin"
          enactor.update(l5r_sheet_type: sheet_type)
          client.emit_success t('l5r.sheet_type_set', :sheet_type => sheet_type.titlecase)
        elsif sheet_type == "samurai"
          enactor.update(l5r_sheet_type: sheet_type)
          client.emit_success t('l5r.sheet_type_set', :sheet_type => sheet_type.titlecase)
        else
          client.emit_failure t('l5r.invalid_sheet_type')
        end
      end
    end
  end
end
