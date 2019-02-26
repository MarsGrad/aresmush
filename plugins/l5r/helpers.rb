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
      else
        calc = char.l5r_traits.select { |t| t.name == 'perception' || t.name == 'strength' }
                   .map { |t| t.rank }
        return calc.min
      end
    end

    def self.can_manage_abilities?(actor)
      return false if !actor
      actor.has_permission?("manage_apps")
    end

    def self.find_trait(model, ability_name)
      name_downcase = ability_name.downcase
      model.l5r_traits.select { |a| a.name.downcase == name_downcase }.first
    end

    def self.find_family_config(family_name)
      return nil if !family_name
      families = Global.read_config('l5r', 'families')
      families.select { |f| f['name'].downcase == family_name.downcase }.first
    end

    def self.find_school_config(school_name)
      return nil if !school_name
      schools = Global.read_config('l5r,' 'schools')
      schools.select { |s| s['name'].downcase == school_name.downcase }.first
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
      schools = Global.read_config("l5r", "schools").map { |s| f['name'].downcase }
      schools.include?(school.downcase)
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
