module AresMUSH
  module L5R
    class ClanDisplayTemplate < ErbTemplateRenderer
      attr_accessor :clan_config

      def initialize(clan_config)
        @clan_config = clan_config
        super File.dirname(__FILE__) + "/clan_display.erb"
      end

      def name
        name = clan_display['name']
        display = "%xyName:%xn #{name}"
        display
      end

      def trait
        trait = clan_display['trait_bonus']
        display = "%xyBonge/Geisha Trait Bonus:%xn #{trait}"
        display
      end

      def skills
        skills = clan_display['skills'].join(", ")
        display = "%xyBonge/Geisha Skills:%xn #{display}"
        display
      end

      def page
        page = clan_display['pg']
        display = "%xyBook:%xn #{page}"
        display
      end
    end
  end
end
