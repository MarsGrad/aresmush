module AresMUSH
  module Channels
    class ChannelReportCmd
      include CommandHandler
           
      attr_accessor :name, :reason
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.name = titlecase_arg(args.arg1)
        self.reason = args.arg2
      end
      
      def required_args
        [ self.name, self.reason ]
      end
      
      def handle
        Channels.with_an_enabled_channel(self.name, client, enactor) do |channel|
          messages = channel.messages.map { |m| "  [#{OOCTime.local_long_timestr(enactor, m['timestamp'])}] #{channel.display_name} #{m['message']}"}.join("%R")

          body = t('channels.channel_reported_body', :name => channel.name, :reporter => enactor_name)
          body << self.reason
          body << "%R-------%R"
          body << messages

          Jobs.create_job(Jobs.trouble_category, t('channels.channel_reported_title'), body, Game.master.system_character)
          client.emit_success t('channels.channel_reported')
          
          
        end
      end
    end  
  end
end