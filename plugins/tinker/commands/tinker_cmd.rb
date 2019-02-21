module AresMUSH
  module Tinker
    class TinkerCmd
      include CommandHandler
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !enactor.has_permission?("tinker")
        return nil
      end
      
      def handle
        result = ClassTargetFinder.find("Celestial Heavens", Room, enactor)
        if (result.found)
            client.emit_success "Found #{result.target}"
        else
            client.emit_failure "#{result.error}"
        end
      end

    end
  end
end
