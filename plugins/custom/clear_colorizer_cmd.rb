module AresMUSH
  module Custom
    class ClearColorizerCmd
      include CommandHandler

      def check_can_clear
        return t('dispatcher.not_allowed') if !enactor.has_role?('admin')
        return nil
      end

      def handle
        name = enactor.admin_name
        enactor.update(name: name)
        client.emit_success "Name decolorized!"
      end
    end
  end
end
