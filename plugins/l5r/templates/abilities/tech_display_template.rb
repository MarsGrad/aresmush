module AresMUSH
  module L5R
    class TechDisplayTemplate < ErbTemplateRenderer
      attr_accessor :tech_config

      def initialize(tech_config)
        @tech_config = tech_config
        super File.dirname(__FILE__) + "/tech_display.erb"
      end

      def name_school
        name = tech_config['name']
        school = tech_config['school']
        display = left("%xyName:%xn #{name}", 30)
        display << "%xySchool:%xn #{school}"
        display
      end

      def rank
        rank = tech_config['rank']
        display = "%xyRank: #{rank}"
        display
      end

      def page
        page = tech_config['pg']
        display = "%xyBook:%xn #{page}"
        display
      end
    end
  end
end
