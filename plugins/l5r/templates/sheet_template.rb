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

      def kata
        char.l5r_kata.to_a.sort_by { |k| [k.ring, k.mastery, k.name] }
      end

      def kiho
        char.l5r_kiho.to_a.sort_by { |k| [k.ring, k.mastery, k.name] }
          .each_with_index
            .map do |k, i|
              linebreak = i % 2 == 0 ? "\n" : ""
              title = "%xh#{k.name}%xn"
              rating = "#{k.ring}/#{k.mastery}"
              display = left("#{title}: #{rating}", 36)
              if i == 0
                "#{display}"
              else
                "#{linebreak}#{display}"
              end
            end
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

      def fire_spell_pool
        fire_spell_pool = center("%xrFire Spells:%xn ", 20)
        fire_spell_pool << format_bar(char.l5r_fire_spell_pool, L5R.calc_l5r_ring(char, "fire"))
        fire_spell_pool
      end

      def air_spell_pool
        air_spell_pool = center("%xhAir Spells:%xn ", 20)
        air_spell_pool << format_bar(char.l5r_air_spell_pool, L5R.calc_l5r_ring(char, "air"))
        air_spell_pool
      end

      def water_spell_pool
        water_spell_pool = center("%xbWater Spells:%xn ", 20)
        water_spell_pool << format_bar(char.l5r_water_spell_pool, L5R.calc_l5r_ring(char, "water"))
        water_spell_pool
      end

      def earth_spell_pool
        earth_spell_pool = center("%x3Earth Spells:%xn ", 20)
        earth_spell_pool << format_bar(char.l5r_earth_spell_pool, L5R.calc_l5r_ring(char, "earth"))
        earth_spell_pool
      end

      def void_spell_pool
        void_spell_pool = center("%x8Void Spells:%xn ", 20)
        void_spell_pool << format_bar(char.l5r_void_spell_pool, char.l5r_void_ring)
        void_spell_pool
      end

      def honor
        honor = char.l5r_honor
        display = "Honor: #{honor}"
        display
      end

      def glory
        glory = char.l5r_glory
        display = "Glory: #{glory}"
        display
      end

      def status
        status = char.l5r_status
        display = "Status: #{status}"
        display
      end

      def armor
        armor = L5R.calc_l5r_armor(char)
        display = "Armor TN: #{armor}"
        display
      end

      def stance
        stance = char.l5r_stance
        display = "Stance: #{stance}"
        display
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

      def health
        status = L5R.calc_l5r_wound_status(char)
        if status == "Healthy"
          display = left("%xgWounds:%xn ", 14)
          display << format_bar(char.l5r_current_wounds, L5R.calc_l5r_max_wounds(char))
          display << "%r%xgHealthy: No TN Penalties -- Largely Undamaged%xn"
        elsif status == "Nicked"
          display = left("%x47Wounds:%xn ", 14)
          display << format_bar(char.l5r_current_wounds, L5R.calc_l5r_max_wounds(char))
          display << "%r%x47Nicked: TNs +3 -- Mild but distracting injury%xn"
        elsif status == "Grazed"
          display = left("%x120Wounds:%xn ", 14)
          display << format_bar(char.l5r_current_wounds, L5R.calc_l5r_max_wounds(char))
          display << "%r%x120Grazed: TN +5 -- Injured, but still able to function without tremendous difficulty%xn"
        elsif status == "Hurt"
          display = left("%x136Wounds:%xn ", 14)
          display << format_bar(char.l5r_current_wounds, L5R.calc_l5r_max_wounds(char))
          display << "%r%x136Hurt: TN +10 -- Begun to suffer noticeably from injuries%xn"
        elsif status == "Injured"
          display = left("%x166Wounds:%xn ", 14)
          display << format_bar(char.l5r_current_wounds, L5R.calc_l5r_max_wounds(char))
          display << "%r%x166Injured: TN +15 -- Difficulty focusing attention on the task at hand%xn"
        elsif status == "Crippled"
          display = left("%x203Wounds:%xn ", 14)
          display << format_bar(char.l5r_current_wounds, L5R.calc_l5r_max_wounds(char))
          display << "%r%x203Crippled:TN +20 -- Can barely stand, much less move. Move actions increase in action step (Free becomes Simple, etc.)%xn"
        elsif status == "Down"
          display = left("%x197Wounds:%xn ", 14)
          display << format_bar(char.l5r_current_wounds, L5R.calc_l5r_max_wounds(char))
          display << "%r%x197Down: TN +40 -- Virtually incapacitated. May speak only in whisper, only take Free Actions (costs a Void point), and can't move.%xn"
        elsif status == "Out"
          display = left("%xrWounds:%xn ", 14)
          display << format_bar(char.l5r_current_wounds, L5R.calc_l5r_max_wounds(char))
          display << "%r%xrOut: Actions unavailable -- Immobile, unconscious, and likely dying. Any damage above this level means death%xn"
        elsif status == "Dead"
          display = left("%xh%xxWounds:%xn ", 14)
          display << format_bar(char.l5r_current_wounds, L5R.calc_l5r_max_wounds(char))
          display << "%r%xh%xxDead: Your character has likely died. You may be entitled to a final Dramatic Moment.%xn"
        end
        display
      end
    end
  end
end
