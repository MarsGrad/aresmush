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
        fire = L5R.calc_l5r_ring(char, 'fire')
        fire << "\n"
        fire << char.l5r_traits.to_a.select { |t| t.name == 'agility' || t.name == 'intelligence' }
                     .each_with_index
                     .map do |t|
                       name = left("#{t.name}:", 15)
                       rank = left(t.rank, 20)
                       "%xr#{name}%xn: #{rank}"
                     end
        fire
      end


      def rings
        fire = L5R.calc_l5r_ring(char, 'fire')
        air = L5R.calc_l5r_ring(char, 'air')
        water = L5R.calc_l5r_ring(char, 'water')
        earth = L5R.calc_l5r_ring(char, 'earth')
        void = char.l5r_void_ring

        rings = "Fire: #{fire}%tAir: #{air}%tWater: #{water}%tEarth: #{earth}%tVoid: #{void}"
      end

      def format_two_per_line(list)
        list.to_a.sort_by { |a| a.name }
          .each_with_index
            .map do |a, i|
              linebreak = i % 2 == 0 ? "\n" : ""
              title = left("#{ a.name }:", 15)
              rating = left(a.rank, 20)
              "#{linebreak}%xh#{title}%xn #{rating}"
            end
      end

    end
  end
end
