module AresMUSH
  module FS3Combat
    def self.damage_severities
      [ 'HEAL', 'GRAZE', 'FLESH', 'IMPAIR', 'INCAP' ]
    end
    
    def self.can_manage_damage?(actor)
      return actor.has_any_role?(Global.read_config("fs3combat", "roles", "can_manage_damage"))
    end

    def self.can_setup_hospitals?(actor)
      return actor.has_any_role?(Global.read_config("fs3combat", "roles", "can_setup_hospitals"))
    end
    
    def self.display_severity(value)
      case value
      when 'HEAL'
        t('fs3combat.healed_wound')
      when 'GRAZE'
        t('fs3combat.graze_wound')
      when 'FLESH'
        t('fs3combat.flesh_wound')
      when 'IMPAIR'
        t('fs3combat.impaired_wound')
      when 'INCAP'
        t('fs3combat.incap_wound')
      end
    end
    
    def self.inflict_damage(char_or_npc, severity, desc, is_stun = false, is_mock = false)
      Global.logger.info "Damage inflicted on #{char_or_npc.name}: #{desc} #{severity} stun=#{is_stun}"

      params = {
        :description => desc,
        :current_severity => severity,
        :initial_severity => severity,
        :ictime_str => ICTime::Api.ic_datestr(ICTime::Api.ictime),
        :healing_points => FS3Combat.healing_points(severity),
        :is_stun => is_stun, 
        :is_mock => is_mock
      }
      if (char_or_npc.class == Character)
        params[:character] = char_or_npc
      else
        params[:npc] = char_or_npc
      end
      
      Damage.create(params)
     end
     
     def self.is_in_hospital?(char)
       Room.find(is_hospital: true).include?(char.room)
     end
     
     def self.healing_points(wound_level)
       Global.read_config("fs3combat", "healing_points", wound_level)
     end
     
     def self.print_damage(total_damage_mod)
       num_xs = [ total_damage_mod.ceil, 4 ].min
       dots = num_xs.times.collect { "X" }.join
       dashes = (4 - num_xs).times.collect { "-" }.join
       "#{dots}#{dashes}"
     end
     
     def self.total_damage_mod(char_or_npc)
       mod = 0
       char_or_npc.damage.each do |w|
         mod = mod + w.wound_mod
       end
       -mod
     end
     
     def self.treat_skill
       Global.read_config("fs3combat", "treat_skill")
     end
     
     def self.healing_skill
       Global.read_config("fs3combat", "healing_skill")
     end
     
     def self.max_patients(char)
       rating = FS3Skills.ability_rating(char, FS3Combat.healing_skill)
       rating / 2
     end
     
     def self.heal_wounds(char)
       wounds = char.damage.select { |d| d.healing_points > 0 } 
       return if wounds.empty?
       
       ability = Global.read_config("fs3combat", "recovery_skill")
       roll_params = FS3Skills::RollParams.new(ability)
       recovery_roll = FS3Skills::Api.one_shot_roll(nil, char, roll_params)
       in_hospital = FS3Combat.is_in_hospital?(char)
       doctors = char.doctors.map { |d| d.name }
       points = ((1 + recovery_roll[:successes]) / 2.0).ceil
       
       if (in_hospital || doctors.count > 0)
         points += 1
       end
       
       Global.logger.info "Healing wounds on #{char.name}: #{doctors} #{in_hospital} #{recovery_roll[:successes]}."
       
       wounds.each do |d|
         FS3Combat.heal(d, points)
       end
     end
     
     def self.worst_treatable_wound(char_or_npc)
       treatable = char_or_npc.damage.select { |d| d.is_treatable? }
       return nil if treatable.empty?

              
       treatable.sort_by { |d| FS3Combat.damage_severities.index(d.current_severity) }.reverse.first
     end
     
     def self.treat(patient_char_or_npc, healer_char_or_npc)
       wound = FS3Combat.worst_treatable_wound(patient_char_or_npc)
       healer_name = healer_char_or_npc.name
       patient_name = patient_char_or_npc.name
       
       if (!wound)
         return t('fs3combat.no_treatable_wounds', :healer => healer_name, :patient => patient_name)
       end
       
       skill = FS3Combat.treat_skill 
       
       roll = healer_char_or_npc.roll_ability(skill)
       successes = roll[:successes]
       
       
       if (successes <= 0)
         return t('fs3combat.treat_failed', :healer => healer_name, :patient => patient_name)
       end
       
       Global.logger.info "Treat: #{healer_name} treating #{patient_name}: #{roll}"
       FS3Combat.heal(wound, 1)
       t('fs3combat.treat_success', :healer => healer_name, :patient => patient_name)
     end
     
    
     def self.heal(wound, points)
       healing = wound.healing_points
       return if healing == 0

       healing = healing - points      
    
       # Wound going down a level.
       if (healing <= 0)
         new_severity_index = FS3Combat.damage_severities.index(wound.current_severity) - 1
         new_severity = FS3Combat.damage_severities[new_severity_index]
         wound.current_severity = new_severity
         wound.healing_points = FS3Combat.healing_points(new_severity)
       else
         wound.healing_points = healing
       end

       wound.healed = true
       wound.save
     end
  
  end
end