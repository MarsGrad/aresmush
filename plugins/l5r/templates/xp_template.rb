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

      def xp_log
        xp_logs = char.l5r_xp_logs.to_a.sort_by { |l| l.date }
        xp_logs = xp_logs[0...4]
        xp_logs
      end
    end
  end
end
