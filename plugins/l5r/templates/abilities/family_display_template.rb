module AresMUSH
  module L5R
    class FamilyDisplayTemplate < ErbTemplateRenderer
      attr_accessor :family_config

      def initialize(family_config)
        @family_config = family_config
        super File.dirname(__FILE__) + "/family_display.erb"
      end

      def name_clan
        name = family_config['name']
        clan = family_config['clan']
        display = left("%xyName:%xn #{name}", 45)
        display << "%xyClan:%xn #{clan}"
        display
      end

      def trait
        trait = family_config['trait_bonus']
        display = "%xyTrait Bonus:%xn #{trait}"
        display
      end

      def page
        page = family_config['pg']
        display = "%xyBook:%xn #{page}"
        display
      end
    end
  end
end
