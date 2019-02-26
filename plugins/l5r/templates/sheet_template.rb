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
        char.l5r_skills.to_a.sort_by { |s| s.name }
      end

      def emphases(skill)
        skill.emphases.map { |k| "#{k}" }.join(", ")
      end

      def fire_air_ring_title
        fire_air = "Fire Ring: #{L5R.calc_l5r_ring(char, 'fire')}"
        fire_air
      end

      def fire_ring_traits
        traits = char.l5r_traits.select { |t| t.name == 'agility' || t.name == 'intelligence' }
        trait1, trait2 = traits[0], traits[1]
        fire = center("%xr#{trait1.name.titlecase}%xn: #{trait1.rank}%t", 20)
        fire << right("%xr#{trait2.name.titlecase}%xn: #{trait2.rank}", 20)
        fire
      end

      def air_ring_title
        air = "Air Ring: #{L5R.calc_l5r_ring(char, 'air')}"
        air
      end

      def air_ring_traits
        traits = char.l5r_traits.select { |t| t.name == 'reflexes' || t.name == 'awareness' }
        trait1, trait2 = traits[0], traits[1]
        air = center("%xh#{trait1.name.titlecase}%xn: #{trait1.rank}%t", 20)
        air << right("%xh#{trait2.name.titlecase}%xn: #{trait2.rank}", 20)
        air
      end

      def water_ring_title
        water = "Water Ring: #{L5R.calc_l5r_ring(char, 'water')}"
        water
      end

      def water_ring_traits
        traits = char.l5r_traits.select { |t| t.name == 'strength' || t.name == 'perception' }
        trait1, trait2 = traits[0], traits[1]
        water = center("%x27#{trait1.name.titlecase}%xn: #{trait1.rank}%t", 20)
        water << right("%x27#{trait2.name.titlecase}%xn: #{trait2.rank}", 20)
        water
      end

      def earth_ring_title
        earth = "Earth Ring: #{L5R.calc_l5r_ring(char, 'earth')}"
        earth
      end

      def earth_ring_traits
        traits = char.l5r_traits.select { |t| t.name == 'stamina' || t.name == 'willpower' }
        trait1, trait2 = traits[0], traits[1]
        earth = center("%x3#{trait1.name.titlecase}%xn: #{trait1.rank}%t", 20)
        earth << right("%x3#{trait2.name.titlecase}%xn: #{trait2.rank}", 20)
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
