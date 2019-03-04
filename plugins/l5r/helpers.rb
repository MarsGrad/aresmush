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

    def self.find_tech(model, tech_name)
      name_downcase = tech_name.downcase
      model.l5r_techniques.select { |t| t.name.downcase == name_downcase }.first
    end

    def self.find_spell(model, spell_name)
      name_downcase = spell_name.downcase
      model.l5r_spells.select { |s| s.name.downcase == name_downcase }.first
    end

    def self.find_advantage(model, advantage_name, descriptor = nil)
      name_downcase = advantage_name.downcase
      if !descriptor
        model.l5r_advantages.select { |a| a.name.downcase == name_downcase }.first
      else
        descriptor_downcase = descriptor.downcase
        model.l5r_advantages.select { |a| a.name.downcase == name_downcase && a.descriptor.downcase == descriptor_downcase }
      end
    end

    def self.find_kata(model, kata_name)
      name_downcase = kata_name.downcase
      model.l5r_kata.select { |k| k.name.downcase == name_downcase }.first
    end

    def self.find_kiho(model, kiho_name)
      name_downcase = kiho_name.downcase
      model.l5r_kiho.select { |k| k.name.downcase == name_downcase }.first
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

    def self.find_tech_config(tech_name)
      return nil if !tech_name
      techs = Global.read_config('l5r', 'techniques')
      techs.select { |t| t['name'].downcase == tech_name.downcase }.first
    end

    def self.find_spell_config(spell_name)
      return nil if !spell_name
      spells = Global.read_config('l5r', 'spells')
      spells.select { |s| s['name'].downcase == spell_name.downcase }.first
    end

    def self.find_advantage_config(adv_name)
      return nil if !adv_name
      advs = Global.read_config('l5r', 'advantages')
      advs.select { |a| a['name'].downcase == adv_name.downcase }.first
    end

    def self.find_kata_config(kata_name)
      return nil if !kata_name
      katas = Global.read_config('l5r', 'kata')
      katas.select { |k| k['name'].downcase == kata_name.downcase }.first
    end

    def self.find_kiho_config(kiho_name)
      return nil if !kiho_name
      kihos = Global.read_config('l5r', 'kiho')
      kihos.select { |k| k['name'].downcase == kiho_name.downcase }.first
    end

    def self.find_skill_config(skill_name)
      return nil if !skill_name
      skills = Global.read_config('l5r', 'skills')
      skills.select { |s| s['name'].downcase == skill_name.downcase }.first
    end

    def self.find_trait_config(trait_name)
      return nil if !trait_name
      traits = Global.read_config('l5r', 'traits')
      traits.select { |t| t['name'].downcase == trait_name.downcase }.first
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
      when "insight"
        return L5R.calc_l5r_insight(char)
      end

      [ char.l5r_skills, char.l5r_traits, char.l5r_schools ].each do |list|
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

    def self.modify_xp(char, amount)
      char.update(l5r_xp: char.l5r_xp + amount)
    end

    def self.award_xp(char, amount)
      L5R.modify_xp(char, amount)
    end

    def self.spend_xp(char, amount)
      L5R.modify_xp(char, -amount)
    end

    def self.can_manage_xp?(actor)
      actor.has_permission?("manage_abilities")
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
      elsif !name.include?(name.downcase)
        check = macro.map { |m| name.start_with?(m) }
        if (check.include?(true))
          return true
        else
          return false
        end
      end
    end
  end
end
