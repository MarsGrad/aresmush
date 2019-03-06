module AresMUSH
  module L5R
    class SpellBurnCmd
      include CommandHandler
      attr_accessor :pool_name, :amount

      def parse_args
        if cmd.args =~ /\=/
          self.pool_name = downcase_arg(cmd.args.before("="))
          self.amount = integer_arg(cmd.args.after("="))
        else
          self.pool_name = downcase_arg(cmd.args)
          self.amount = 1
        end
      end

      def handle
        if self.pool_name == "fire"
          new_total = enactor.l5r_fire_spell_pool - self.amount
          if new_total < 0
            client.emit_failure t('l5r.pool_minimum')
            return
          end
        elsif self.pool_name == "air"
          new_total = enactor.l5r_air_spell_pool - self.amount
          if new_total < 0
            client.emit_failure t('l5r.pool_minimum')
            return
          end
        elsif self.pool_name == "earth"
          new_total = enactor.l5r_earth_spell_pool - self.amount
          if new_total < 0
            client.emit_failure t('l5r.pool_minimum')
            return
          end
        elsif self.pool_name == "water"
          new_total = enactor.l5r_water_spell_pool - self.amount
          if new_total < 0
            client.emit_failure t('l5r.pool_minimum')
            return
          end
        elsif self.pool_name == "void"
          new_total = enactor.l5r_void_spell_pool - self.amount
          if new_total < 0
            client.emit_failure t('l5r.pool_minimum')
            return
          end
        else
          client.emit_failure t('l5r.invalid_ring')
          return
        end

        if self.pool_name == "fire"
          enactor.update(l5r_fire_spell_pool: new_total)
          Global.logger.debug "L5R: #{enactor_name} burning #{self.amount} Fire Spell Slot(s)."
          Rooms.emit_ooc_to_room enactor_room, t('l5r.spell_pool_burn', :character => enactor_name, :amount => self.amount, :pool => "Fire")
        elsif self.pool_name == "air"
          enactor.update(l5r_air_spell_pool: new_total)
          Global.logger.debug "L5R: #{enactor_name} burning #{self.amount} Air Spell Slot(s)."
          Rooms.emit_ooc_to_room enactor_room, t('l5r.spell_pool_burn', :character => enactor_name, :amount => self.amount, :pool => "Air")
        elsif self.pool_name == "water"
          enactor.update(l5r_water_spell_pool: new_total)
          Global.logger.debug "L5R: #{enactor_name} burning #{self.amount} Water Spell Slot(s)."
          Rooms.emit_ooc_to_room enactor_room, t('l5r.spell_pool_burn', :character => enactor_name, :amount => self.amount, :pool => "Water")
        elsif self.pool_name == "earth"
          enactor.update(l5r_earth_spell_pool: new_total)
          Global.logger.debug "L5R: #{enactor_name} burning #{self.amount} Earth Spell Slot(s)."
          Rooms.emit_ooc_to_room enactor_room, t('l5r.spell_pool_burn', :character => enactor_name, :amount => self.amount, :pool => "Earth")
        elsif self.pool_name == "void"
          enactor.update(l5r_void_spell_pool: new_total)
          Global.logger.debug "L5R: #{enactor_name} burning #{self.amount} Void Spell Slot(s)."
          Rooms.emit_ooc_to_room enactor_room, t('l5r.spell_pool_burn', :character => enactor_name, :amount => self.amount, :pool => "Void")
        end
      end
    end
  end
end
