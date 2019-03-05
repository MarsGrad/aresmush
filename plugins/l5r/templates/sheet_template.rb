module AresMUSH
  module L5R
    class SheetTemplate < ErbTemplateRenderer
      attr_accessor :char

      def initialize(char)
        @char = char
        super File.dirname(__FILE__) + "/sheet.erb"
      end

      def shugenja
        shugenja = char.l5r_is_shugenja
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

      def school
        schools = char.l5r_schools.map { |s| "#{s.name}" + ": " + "#{s.rank}" }
        if (schools)
          "School: #{schools.join(', ').titlecase}"
        else
          "School: "
        end
      end

      def order
        orders = char.l5r_schools.map { |s| "#{s.name}" + ": " + "#{s.rank}" }
        if (orders)
          "Order: #{orders.join(', ').titlecase}"
        else
          "Order: "
        end
      end

      def insight
        rank = L5R.calc_l5r_insight(char)
        "Insight Rank: #{rank}"
      end

      def affinity
        aff = char.l5r_affinity
        if aff
          "Affinity: #{aff}"
        else
          "Affinity: "
        end
      end

      def deficiency
        defic = char.l5r_deficiency
        if defic
          "Deficiency: #{char.l5r_deficiency}"
        else
          "Deficiency: "
        end
      end

      def skills
        char.l5r_skills.to_a.sort_by { |s| s.name }
      end

      def emphases(skill)
        skill.emphases.map { |k| "#{k}" }.join(", ")
      end

      def techs
        char.l5r_techniques.to_a.sort_by { |t| t.rank }
      end

      def spells
        @char.l5r_spells.to_a.sort_by { |a| [a.ring, a.mastery, a.name] }
          .each_with_index
            .map do |a, i|
              linebreak = i % 2 == 0 ? "\n" : ""
              title = "%xh#{a.name}%xn"
              rating = "#{a.ring}/#{a.mastery}"
              display = left("#{title}: #{rating}", 36)
              if i == 0
                "#{display}"
              else
                "#{linebreak}#{display}"
              end
            end
      end

      def advantages
        char.l5r_advantages.to_a.sort_by { |a| a.name }
          .map do |a|
            title = "%xh#{a.name}%xn"
            rank = "#{a.rank}"
            display = "#{title}: "
            if a.descriptor
              descriptor = "#{a.descriptor}"
              display << "(#{descriptor})"
            end
            ["#{display}", "#{rank}"]
          end
      end

      def disadvantages
        char.l5r_disadvantages.to_a.sort_by { |d| d.name }
          .map do |d|
            title = "%xh#{d.name}%xn"
            rank = "#{d.rank}"
            display = "#{title}: "
            if d.descriptor
              descriptor = "#{d.descriptor}"
              display << "(#{descriptor})"
            end
            ["#{display}", "#{rank}"]
          end
      end

      def fire_air_ring_title
        fire_air = "Fire Ring: #{L5R.calc_l5r_ring(char, 'fire')} ]-----------------------[ Air Ring: #{L5R.calc_l5r_ring(char, 'air')}"
        fire_air
      end

      def fire_ring_traits
        traits = char.l5r_traits.select { |t| t.name == 'agility' || t.name == 'intelligence' }
        trait1, trait2 = traits[0], traits[1]
        fire = center("%xr#{trait1.name.titlecase}%xn: #{trait1.rank}%t", 20)
        fire << right("%xr#{trait2.name.titlecase}%xn: #{trait2.rank}", 20)
        fire
      end

      def void_ring_title
        "Void Ring: #{char.l5r_void_ring}"
      end

      def air_ring_traits
        traits = char.l5r_traits.select { |t| t.name == 'reflexes' || t.name == 'awareness' }
        trait1, trait2 = traits[0], traits[1]
        air = center("%xh#{trait1.name.titlecase}%xn: #{trait1.rank}%t", 20)
        air << right("%xh#{trait2.name.titlecase}%xn: #{trait2.rank}", 20)
        air
      end

      def water_ring_traits
        traits = char.l5r_traits.select { |t| t.name == 'strength' || t.name == 'perception' }
        trait1, trait2 = traits[0], traits[1]
        water = center("%x27#{trait1.name.titlecase}%xn: #{trait1.rank}%t", 20)
        water << right("%x27#{trait2.name.titlecase}%xn: #{trait2.rank}", 20)
        water
      end

      def earth_water_ring_title
        earth_water = "Earth Ring: #{L5R.calc_l5r_ring(char, 'earth')} ]----------------------[ Water Ring: #{L5R.calc_l5r_ring(char, 'water')}"
        earth_water
      end

      def earth_ring_traits
        traits = char.l5r_traits.select { |t| t.name == 'stamina' || t.name == 'willpower' }
        trait1, trait2 = traits[0], traits[1]
        earth = center("%x3#{trait1.name.titlecase}%xn: #{trait1.rank}%t", 20)
        earth << right("%x3#{trait2.name.titlecase}%xn: #{trait2.rank}", 20)
        earth
      end

      def void_pool
        void_pool = center("%x8Void Pool:%xn ", 14)
        void_pool << format_bar(char.l5r_void_pool, char.l5r_void_ring)
        void_pool
      end

      def format_bar(current, max)
        current = current || 0
        max = max || 10
        x = current.times.map { |i| '{%xr*%xn}' }.join
        o = (max - current).times.map { |i| '{ }' }.join
        "#{x}#{o} (#{current}/#{max})"
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
