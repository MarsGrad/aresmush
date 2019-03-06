module AresMUSH
  module L5R
    class SkillDisplayTemplate < ErbTemplateRenderer
      attr_accessor :skill_config

      def initialize(skill_config)
        @skill_config = skill_config
        super File.dirname(__FILE__) + "/skill_display.erb"
      end

      def name_level
        name = skill_config['name']
        level = skill_config['level']
        display = left("%xyName:%xn #{name}", 45)
        display << "%xyLevel:%xn #{level}"
        display
      end

      def subtype_trait
        subtype = skill_config['subtypes']
        trait = skill_config['default_trait']
        display = left("%xySubtypes:%xn #{subtype}", 45)
        display << "%xyDefault Trait:%xn #{trait}"
        display
      end

      def emphases
        emp = skill_config['emphases']
        display = "%xyExample Emphases:%xn #{emp}"
        display
      end

      def specialties
        specs = skill_config['specialties']
        display = "%xyExample specialties:%xn #{specs}"
        display
      end

      def desc
        desc = skill_config['description']
        display = "%xyDescription:%xn #{desc}"
        display
      end

      def page
        page = skill_config['pg']
        display = "%xyBook:%xn #{page}"
        display
      end
    end
  end
end
