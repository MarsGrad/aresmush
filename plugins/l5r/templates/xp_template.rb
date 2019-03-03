module AresMUSH
  module L5R
    class XpTemplate < ErbTemplateRenderer
      attr_accessor :char

      def initialize(char)
        @char = char
        super File.dirname(__FILE__) + "/xp.erb"
      end

      def xp
        char.l5r_xp
      end
    end
  end
end
