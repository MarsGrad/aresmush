module AresMUSH
  module L5R
    def self.find_school_config(school_name)
      return nil if !school_name
      schools = Global.read_config('l5r', 'schools')
      schools.select { |s| s['name'].downcase == school_name.downcase }.first
    end

  end
end
