module AresMUSH
  module L5R
    class AdvDisplayTemplate < ErbTemplateRenderer
      attr_accessor :adv_config

      def initialize(adv_config)
        @adv_config = adv_config
        super File.dirname(__FILE__) + "/adv_display.erb"
      end

      def name_subtype
        name = adv_config['name']
        subtype = adv_config['subtype']
        display = left("%xyName:%xn #{name}", 45)
        display << "%xySubtype:%xn #{subtype}"
        display
      end

      def ranked
        ranked = adv_config['ranked'].to_s.titlecase
        display = "%xyRanked:%xn #{ranked}"
        display
      end

      def cost
        cost = adv_config['cost']
        display = "%xyCost:%xn #{cost}"
        display
      end

      def restriction
        restriction = adv_config['restriction']
        if (restriction.class == Array)
          restriction = restriction.join(", ")
        end
        display = "%xyRestriction:%xn #{restriction.titlecase}"
        display
      end

      def page
        page = adv_config['pg']
        display = "%xyBook:%xn #{page}"
        display
      end
    end
  end
end
