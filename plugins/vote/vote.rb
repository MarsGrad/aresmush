$:.unshift File.dirname(__FILE__)

module AresMUSH
  module Vote
    def self.plugin_dir
      File.dirname(__FILE__)
    end

    def self.shortcuts
      Global.read_config("vote", "shortcuts")
    end

    def self.get_cmd_handler(client, cmd, enactor)
      return nil if !cmd.root_is?("vote")

      case cmd.switch
      when "here"
        return VoteHereCmd
      when "scene"
        return VoteSceneCmd
      when nil
        if (cmd.args)
          return VoteCmd
        else
          return VotesCmd
        end
      end

      return nil
    end

    def self.get_event_handler(event_name)
      case event_name
      when "CronEvent"
        return CronEventHandler
      end
      nil
    end

    def self.get_web_request_handler(request)
      case request.cmd
      when "sceneVotes"
        return GiveSceneVotesRequestHandler
      end
      nil
    end
  end
end
