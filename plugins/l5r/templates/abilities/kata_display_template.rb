module AresMUSH
  module L5R
    class KataDisplayTemplate < ErbTemplateRenderer
      attr_accessor :kata_config

      def initialize(kata_config)
        @kata_config = kata_config
        super File.dirname(__FILE__) + "/kata_display.erb"
      end

      def name_ring
        name = kata_config['name']
        ring = kata_config['ring']
        display = left("%xyName:%xn #{name}", 45)
        display << "%xyRing:%xn #{ring}"
        display
      end

      def mastery
        mastery = kata_config['mastery']
        display = "%xyMastery: #{mastery}"
        display
      end

      def schools
        schools = kata_config['schools'].join(", ")
        display = "%xySchools:%xn #{schools}"
        display
      end

      def page
        page = kata_config['pg']
        display = "%xyBook:%xn #{page}"
        display
      end
    end
  end
end
