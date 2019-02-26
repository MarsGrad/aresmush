module AresMUSH
  module L5R
    class SheetTemplate < ErbTemplateRenderer
      attr_accessor :char

      def initialize(char)
        @char = char
        super File.dirname(__FILE__) + "/sheet.erb"
      end

      def clan
        if (char.l5r_clan)
          "Clan: #{char.l5r_clan.titlecase}"
        else
          "Clan: "
        end
      end

      def family
        if (char.l5r_family)
          "Family: #{char.l5r_family.titlecase}"
        else
          "Family: "
        end
      end

      def rings
        fire = L5R.calc_l5r_ring(char, 'fire')
        air = L5R.calc_l5r_ring(char, 'air')
        water = L5R.calc_l5r_ring(char, 'water')
        earth = L5R.calc_l5r_ring(char, 'earth')
        void = char.l5r_void_ring

        rings = "Fire: #{fire}%tAir: #{air}%tWater: #{water}%tEarth: #{earth}%tVoid: #{void}"
      end
    end
  end
end
