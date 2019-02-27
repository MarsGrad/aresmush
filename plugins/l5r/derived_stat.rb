module AresMUSH
  module L5R
    def self.derived_stat(char, config_setting)
      stats = Global.read_config("l5r", config_setting)
      ranks = []
      stats.each do |s|
        rank = L5R.find_ability_rank(char, s)
        if (rank)
          ranks << rank
        end
      end
      ranks.join("+")
    end

    def self.initiative(char)
      ranks = []
      ranks << L5R.find_ability_rank(char, "reflexes")
      ranks << L5R.calc_l5r_insight(char)
      ranks.join("+")
    end

  end
end
