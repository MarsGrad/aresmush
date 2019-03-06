module AresMUSH
  module L5R
    class SpellDisplayTemplate < ErbTemplateRenderer
      attr_accessor :spell_config

      def initialize(spell_config)
        @spell_config = spell_config
        super File.dirname(__FILE__) + "/spell_display.erb"
      end

      def name_ring
        name = spell_config['name']
        ring = spell_config['ring']
        display = left("%xyName:%xn #{name}", 45)
        display << "%xyRing:%xn #{ring}"
        display
      end

      def mastery
        mastery = spell_config['mastery']
        display = "%xyMastery:%xn #{mastery}"
        display
      end

      def range
        range = spell_config['range']
        display = "%xyRange:%xn #{range}"
        display
      end

      def aoe
        aoe = spell_config['aoe']
        display = "%xyArea of Effect:%xn #{aoe}"
        display
      end

      def duration
        duration = spell_config['duration']
        display = "%xyDuration:%xn #{duration}"
        display
      end

      def page
        page = spell_config['pg']
        display = "%xyBook:%xn #{page}"
        display
      end
    end
  end
end
