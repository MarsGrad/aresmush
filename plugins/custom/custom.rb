$:.unshift File.dirname(__FILE__)

module AresMUSH
  module Custom
    def self.plugin_dir
      File.dirname(__FILE__)
    end

    def self.shortcuts
      Global.read_config("custom", "shortcuts")
    end

    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "goals"
        case cmd.switch
        when "set"
          return SetGoalsCmd
        else
          return ViewGoalsCmd
        end
      when "colorizer"
        case cmd.switch
        when "set"
          return SetColorizerCmd
        else
          return ClearColorizerCmd
        end
      end
      return nil
    end
  end
end
