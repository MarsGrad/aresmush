module AresMUSH
  module Custom
    class ViewGoalsCmd
      include CommandHandler

      attr_accessor :name

      def parse_args
        self.name = cmd.args ? titlecase_arg(cmd.arg) : enactor_name
      end

      def check_can_view
        return nil if enactor_name == self.name
        return nil if enactor.has_permission?("view_bgs")
        return "You don't have permission to view that."
      end

      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          template = BorderedDisplayTemplate.new model.goals, "#{model.name}'s Goals"
          client.emit template.render
        end
    end
  end
end
