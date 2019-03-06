module AresMUSH
  module L5R
    class OptionsListTemplate < ErbTemplateRenderer
      attr_accessor :paginator, :item

      def initialize(paginator, item)
        @paginator = paginator
        @item = item
        super File.dirname(__FILE__) + "/options_list.erb"
      end

      def title
        item
      end
    end
  end
end
