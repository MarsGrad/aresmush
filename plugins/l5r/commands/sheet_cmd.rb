module AresMUSH
  module L5R
    class SheetCmd
      include CommandHandler

      attr_accessor :target_name

      def parse_args
        self.target_name = cmd.args ? titlecase_arg(cmd.args) : enactor_name
      end

      def check_can_view
        return nil if self.target_name == enactor_name
        return nil if L5R.can_manage_abilities?(enactor)
        return t('dispatcher.not_allowed')
      end

      def check_has_init
        return nil if self.target_name.l5r_void_ring
        return t('l5r.must_init_first')
      end

      def handle
        ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
          template = SheetTemplate.new(model)
          client.emit template.render
        end
      end
    end
  end
end
