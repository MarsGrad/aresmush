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

      def traits
        format_two_per_line char.l5r_traits
      end

      def fire_ring
        fire = "%xrFire Ring%xn: #{L5R.calc_l5r_ring(char, 'fire')}"
        fire << "\n"
        traits = char.l5r_traits.select { |t| t.name == 'agility' || t.name == 'intelligence' }
        trait1, trait2 = traits[0], traits[1]
        fire << left("%xr#{trait1.name.titlecase}%xn: #{trait1.rank}%t", 30)
        fire << left("%xr#{trait2.name.titlecase}%xn: #{trait2.rank}", 30)
        fire
      end

      def air_ring
        air = "%xhAir Ring%xn: #{L5R.calc_l5r_ring(char, 'air')}"
        air << "\n"
        traits = char.l5r_traits.select { |t| t.name == 'reflexes' || t.name == 'awareness' }
        trait1, trait2 = traits[0], traits[1]
        air << left("%xr#{trait1.name.titlecase}%xn: #{trait1.rank}%t", 30)
        air << left("%xr#{trait2.name.titlecase}%xn: #{trait2.rank}", 30)
        air
      end

      def water_ring
        water = "%x27Fire Ring%xn: #{L5R.calc_l5r_ring(char, 'water')}"
        water << "\n"
        traits = char.l5r_traits.select { |t| t.name == 'strength' || t.name == 'perception' }
        trait1, trait2 = traits[0], traits[1]
        water << left("%xr#{trait1.name.titlecase}%xn: #{trait1.rank}%t", 30)
        water << left("%xr#{trait2.name.titlecase}%xn: #{trait2.rank}", 30)
        water
      end

      def earth_ring
        earth = "%x3Earth Ring%xn: #{L5R.calc_l5r_ring(char, 'earth')}"
        earth << "\n"
        traits = char.l5r_traits.select { |t| t.name == 'stamina' || t.name == 'willpower' }
        trait1, trait2 = traits[0], traits[1]
        earth << left("%xr#{trait1.name.titlecase}%xn: #{trait1.rank}%t", 30)
        earth << left("%xr#{trait2.name.titlecase}%xn: #{trait2.rank}", 30)
        earth
      end
    end
  end
end
