module AresMUSH
  module L5R
    class VoidRecoverCmd
      include CommandHandler
      attr_accessor :amount

      def parse_args
        self.amount = integer_arg(cmd.args)
      end

      def handle
        if (self.amount)
          new_total = enactor.l5r_void_pool + self.amount
          if new_total > enactor.l5r_void_ring
            client.emit_failure t('l5r.pool_maximum')
            return
          end
        else
          new_total = enactor.l5r_void_pool + 1
          if new_total > enactor.l5r_void_ring
            client.emit_failure t('l5r.pool_maximum')
            return
          end
        end

        enactor.update(l5r_void_pool: new_total)
        if (self.amount)
          Global.logger.debug "L5R: #{enactor_name} recovering #{self.amount} Void."
          Rooms.emit_ooc_to_room enactor_room, t('l5r.void_pool_recover', :character => enactor_name, :amount => self.amount)
        else
          Global.logger.debug "L5R: #{enactor_name} recovering 1 Void."
          Rooms.emit_ooc_to_room enactor_room, t('l5r.void_pool_recover', :character => enactor_name, :amount => 1)
        end
      end
    end
  end
end
