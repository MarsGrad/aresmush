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

      def school
        schools = char.l5r_schools.map { |s| s.name }
        if (schools)
          "School: #{schools.join(', ').titlecase}"
        else
          "School: "
        end
      end

      def family
        if (char.l5r_family)
          "Family: #{char.l5r_family.titlecase}"
        else
          "Family: "
        end
      end

      def skills
        format_two_per_line char.l5r_skills
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
        air << left("%xh#{trait1.name.titlecase}%xn: #{trait1.rank}%t", 30)
        air << left("%xh#{trait2.name.titlecase}%xn: #{trait2.rank}", 30)
        air
      end

      def water_ring
        water = "%x27Water Ring%xn: #{L5R.calc_l5r_ring(char, 'water')}"
        water << "\n"
        traits = char.l5r_traits.select { |t| t.name == 'strength' || t.name == 'perception' }
        trait1, trait2 = traits[0], traits[1]
        water << left("%x27#{trait1.name.titlecase}%xn: #{trait1.rank}%t", 30)
        water << left("%x27#{trait2.name.titlecase}%xn: #{trait2.rank}", 30)
        water
      end

      def earth_ring
        earth = "%x3Earth Ring%xn: #{L5R.calc_l5r_ring(char, 'earth')}"
        earth << "\n"
        traits = char.l5r_traits.select { |t| t.name == 'stamina' || t.name == 'willpower' }
        trait1, trait2 = traits[0], traits[1]
        earth << left("%x3#{trait1.name.titlecase}%xn: #{trait1.rank}%t", 30)
        earth << left("%x3#{trait2.name.titlecase}%xn: #{trait2.rank}", 30)
        earth
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
