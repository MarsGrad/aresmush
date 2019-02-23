module AresMUSH
  module Custom
    class SetColorizerCmd
      include CommandHandler

      attr_accessor :color_name
      attr_accessor :admin_name

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_slash_arg2)
        self.color_name = trim_arg(args.arg1)
        self.admin_name = titlecase_arg(args.arg2)
      end

      def required_args
        [ self.color_name, self.admin_name ]
      end

      def check_can_set
        return t('dispatcher.not_allowed') if !enactor.has_role?(admin)
        return nil
      end

      def handle
          enactor.update(name: self.color_name)
          enactor.update(admin_name: self.admin_name)
          client.emit_success "Name colorized!"
      end
    end
  end
end
