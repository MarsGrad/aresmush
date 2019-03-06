module AresMUSH
  module L5R
    class KihoDisplayTemplate < ErbTemplateRenderer
      attr_accessor :kiho_config

      def initialize(kiho_config)
        @kiho_config = kiho_config
        super File.dirname(__FILE__) + "/kiho_display.erb"
      end

      def name_ring
        name = kiho_config['name']
        ring = kiho_config['ring']
        display = left("%xyName:%xn #{name}", 45)
        display << "%xyRing:%xn #{ring}"
        display
      end

      def mastery_atemi
        mastery = kiho_config['mastery']
        atemi = kiho_config['atemi'].to_s.titlecase
        display = left("%xyMastery:%xn #{mastery}", 45)
        display << "%xyAtemi:%xn #{atemi}"
        display
      end

      def type
        type = kiho_config['type']
        display = "%xyType:%xn #{type}"
        display
      end

      def page
        page = kiho_config['pg']
        display = "%xyBook:%xn #{page}"
        display
      end
    end
  end
end
