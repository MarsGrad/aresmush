module AresMUSH
  module L5R
    class DisadvDisplayTemplate < ErbTemplateRenderer
      attr_accessor :disadv_config

      def initialize(disadv_config)
        @disadv_config = disadv_config
        super File.dirname(__FILE__) + "/disadv_display.erb"
      end

      def name_subtype
        name = disadv_config['name']
        subtype = disadv_config['subtype']
        display = left("%xyName:%xn #{name}", 45)
        display << "%xySubtype:%xn #{subtype}"
        display
      end

      def ranked
        ranked = disadv_config['ranked'].to_s.titlecase
        if ranked.empty?
          ranked = "False"
        end
        display = "%xyRanked:%xn #{ranked}"
        display
      end

      def cost
        cost = disadv_config['cost']
        display = "%xyCost:%xn #{cost}"
        display
      end

      def restriction
        restriction = disadv_config['restriction']
        if (restriction.class == Array)
          restriction = restriction.join(", ")
        end
        display = "%xyRestriction:%xn #{restriction.titlecase}"
        display
      end

      def page
        page = disadv_config['pg']
        display = "%xyBook:%xn #{page}"
        display
      end
    end
  end
end
