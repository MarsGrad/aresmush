module AresMUSH
  module L5R
    class ProveCmd
      include CommandHandler

      attr_accessor :ability_name

      def parse_args
        self.ability_name = downcase_arg(cmd.args)
      end

      def required_args
        [self.ability_name]
      end

      def handle
        found = nil
        [ enactor.l5r_skills, enactor.l5r_traits, enactor.l5r_schools, enactor.l5r_kiho, enactor.l5r_kata, enactor.l5r_spells, enactor.l5r_advantages, enactor.l5r_disadvantages, enactor.l5r_techniques ].each do |list|
          found = list.select { |a| a.name.downcase == self.ability_name }.first
        end

        if (found)
          if (found.rank)
            Rooms.emit_ooc_to_room enactor.room, t('l5r.prove_ranked', :character => enactor_name, :ability => found.name.titlecase, :rank => found.rank)
          elsif (!found.rank)
            Rooms.emit_ooc_to_room enactor.room, t('l5r.prove', :character => enactor_name, :ability => found.name.titlecase)
          end
          return
        end

        case self.ability_name
        when "fire"
          found = L5R.calc_l5r_ring(enactor, 'fire')
        when "air"
          found = L5R.calc_l5r_ring(enactor, 'air')
        when "earth"
          found = L5R.calc_l5r_ring(enactor, 'earth')
        when "water"
          found = L5R.calc_l5r_ring(enactor, 'water')
        when "void"
          found = enactor.l5r_void_ring
        when "insight"
          found = L5R.calc_l5r_insight(enactor)
        end

        if (!found)
          client.emit_failure t('l5r.invalid_ability_name')
          return
        else
          Rooms.emit_ooc_to_room enactor.room, t('l5r.prove_ranked', :character => enactor_name, :ability => "#{self.ability_name.titlecase} Rank", :rank => found)
        end
      end
    end
  end
end
