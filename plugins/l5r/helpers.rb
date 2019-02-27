module AresMUSH
  module L5R

    def self.calc_l5r_ring(char, ring)
      if ring == 'fire'
        calc = char.l5r_traits.select { |t| t.name == 'agility' || t.name == 'intelligence' }
                   .map { |t| t.rank }
        return calc.min
      elsif ring == 'air'
        calc = char.l5r_traits.select { |t| t.name == 'awareness' || t.name == 'reflexes' }
                   .map { |t| t.rank }
        return calc.min
      elsif ring == 'earth'
        calc = char.l5r_traits.select { |t| t.name == 'willpower' || t.name ==  'stamina' }
                   .map { |t| t.rank }
        return calc.min
      elsif ring == 'water'
        calc = char.l5r_traits.select { |t| t.name == 'perception' || t.name == 'strength' }
                   .map { |t| t.rank }
        return calc.min
      end
    end

    def self.set_l5r_trait(char, trait_name, rank)
      trait = L5R.find_trait(char, trait_name)
      if (trait)
        trait.update(rank: rank)
      else
        L5rTrait.create(name: trait_name, rank: rank, character: char)
      end
    end

    def self.calc_l5r_insight(char)
      fire = L5R.calc_l5r_ring(char, 'fire')
      air = L5R.calc_l5r_ring(char, 'air')
      earth = L5R.calc_l5r_ring(char, 'earth')
      water = L5R.calc_l5r_ring(char, 'water')
      void = char.l5r_void_ring
      skills = char.l5r_skills.map { |s| s.rank }.inject(0){|sum,x| sum + x }
      rings = fire + air + earth + water + void
      insight = (rings * 10) + skills

      if (1..149).include?(insight)
        rank = 1
      elsif (150..174).include?(insight)
        rank = 2
      elsif (175..199).include?(insight)
        rank = 3
      elsif (200..224).include?(insight)
        rank = 4
      elsif (225..249).include?(insight)
        rank = 5
      end

      return rank
    end

    def self.can_manage_abilities?(actor)
      return false if !actor
      actor.has_permission?("manage_apps")
    end

    def self.find_trait(model, ability_name)
      name_downcase = ability_name.downcase
      model.l5r_traits.select { |a| a.name.downcase == name_downcase }.first
    end

    def self.find_skill(model, skill_name)
      name_downcase = skill_name.downcase
      model.l5r_skills.select { |s| s.name.downcase == name_downcase }.first
    end

    def self.find_school(model, school_name)
      name_downcase = school_name.downcase
      model.l5r_schools.select { |s| s.name.downcase == name_downcase }.first
    end

    def self.find_family_config(family_name)
      return nil if !family_name
      families = Global.read_config('l5r', 'families')
      families.select { |f| f['name'].downcase == family_name.downcase }.first
    end

    def self.find_school_config(school_name)
      return nil if !school_name
      schools = Global.read_config('l5r', 'schools')
      schools.select { |s| s['name'].downcase == school_name.downcase }.first
    end

    def self.find_ability_rank(char, ability_name)
      return nil if !ability_name

      case ability_name.downcase
      when "initiative"
        return L5R.initiative(char)
      when "fire"
        return L5R.calc_l5r_ring(char, 'fire')
      when "air"
        return L5R.calc_l5r_ring(char, 'air')
      when "earth"
        return L5R.calc_l5r_ring(char, 'earth')
      when "water"
        return L5R.calc_l5r_ring(char, 'water')
      when "void"
        return char.l5r_void_ring
      end

      [ char.l5r_skills, char.l5r_traits ].each do |list|
        found = list.select { |a| a.name.downcase == ability_name.downcase }.first
        return found.rank if found
      end
      return nil
    end

    def self.format_roll(input)
      return "" if !input
      if input.downcase =~ /\+/
        input.downcase.gsub(" + ", "+")
      else
        input.downcase.gsub(" k ", "k")
      end
    end

    def self.is_valid_clan?(clan)
      return false if !clan
      clans = Global.read_config("l5r", "clans").map { |c| c['name'].downcase }
      clans.include?(clan.downcase)
    end

    def self.is_valid_family?(family)
      return false if !family
      families = Global.read_config("l5r", "families").map { |f| f['name'].downcase }
      families.include?(family.downcase)
    end

    def self.is_valid_school?(school)
      return false if !school
      schools = Global.read_config("l5r", "schools").map { |s| s['name'].downcase }
      schools.include?(school.downcase)
    end

    def self.is_valid_rk?(roll_str)
      /\d+k\d+/.match?(roll_str)
    end

    def self.is_valid_l5r_skill_name?(name)
      return false if !name
      names = Global.read_config('l5r', 'skills').map { |a| a['name'].downcase }
      macro = ["lore", "artisan", "games", "perform", "craft"]
      if names.include?(name.downcase)
        !macro.include?(name.downcase)
      elsif !names.include?(name.downcase)
        name.starts_with?(*macro)
      end
    end
  end
end
