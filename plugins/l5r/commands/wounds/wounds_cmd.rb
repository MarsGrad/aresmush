module AresMUSH
  module L5R
    class WoundsCmd
      include CommandHandler

      attr_accessor :target_name

      def parse_args
        #Admin Version
        if (cmd.args)
          self.target_name = titlecase_arg(cmd.args)
        else
          self.target_name = enactor_name
        end
      end

      def check_can_view
        return nil if enactor_name == self.target_name
        return nil if L5R.can_manage_abilities(enactor)
        return t('dispatcher.not_allowed')
      end

      def handle
        ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
          template = WoundsDisplayTemplate.new(model)
          client.emit template.render
        end
      end
    end
  end
end
