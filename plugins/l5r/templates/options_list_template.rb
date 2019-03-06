module AresMUSH
  module L5R
    class OptionsListTemplate < ErbTemplateRenderer
      attr_accessor :paginator

      def initialize(paginator)
        @paginator = paginator
        super File.dirname(__FILE__) + "/options_list.erb"
      end
    end
  end
end
