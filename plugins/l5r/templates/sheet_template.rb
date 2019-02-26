module AresMUSH
  module L5R
    class SheetTemplate < ErbTemplateRenderer
      attr_accessor :char

      def initialize(char)
        @char = char
        super File.dirname(__FILE__) + "/sheet.erb"
      end

      def summary
        summ = "Clan: #{char.l5r_clan}"
        if (char.l5r_family)
          summ << "%tFamily: #{char.l5r_family}"
        else
          summ << "%tFamily: "
        end
        if (char.l5r_schools)
          summ << "%tSchool: #{char.l5r_schools}"
        else
          summ << "%tSchool: "
        end
        summ
      end

      def rings
        fire = L5R.calc_l5r_ring(char, 'fire')
        air = L5R.calc_l5r_ring(char, 'air')
        water = L5R.calc_l5r_ring(char, 'water')
        earth = L5R.calc_l5r_ring(char, 'earth')
        void = L5R.l5r_void_ring

        rings = "Fire: #{fire}%tAir: #{air}%tWater: #{water}%tEarth: #{earth}%tVoid: #{void}"
      end
    end
  end
end
