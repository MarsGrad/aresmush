$:.unshift File.dirname(__FILE__)

module AresMUSH
     module L5R

    def self.plugin_dir
      File.dirname(__FILE__)
    end

    def self.shortcuts
      Global.read_config("l5r", "shortcuts")
    end

    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "sheet"
        case cmd.switch
        when "init"
          return SheetInitCmd
        else
          if (!cmd.switch)
            return SheetCmd
          end
        end
      when "school"
        case cmd.switch
        when "set"
          return SchoolSetCmd
        when "rem"
          return SchoolRemCmd
        else
          if (!cmd.switch)
            return SchoolCmd
          end
        end
      when "tech"
        case cmd.switch
        when "add"
          return TechAddCmd
        when "rem"
          return TechRemCmd
        else
          if (!cmd.switch)
            return TechCmd
          end
        end
      when "spell"
        case cmd.switch
        when "add"
          return SpellAddCmd
        elswhen "rem"
          return SpellRemCmd
        else
          if (!cmd.switch)
            return SpellCmd
          end
        end
      when "kata"
        case cmd.switch
        when "add"
          return KataAddCmd
        elswhen "rem"
          return KataRemCmd
        else
          if (!cmd.switch)
            return KataCmd
          end
        end
      when "kiho"
        case cmd.switch
        when "add"
          return KihoAddCmd
        when "rem"
          return KihoRemCmd
        else
          if (!cmd.switch)
            return KihoCmd
          end
        end
      when "family"
        when "set"
          return FamilySetCmd
        when "rem"
          return FamilyRemCmd
        else
          if (!cmd.switch)
            return FamilyCmd
          end
        end
      end

      return nil
    end

    def self.get_event_handler(event_name)
      nil
    end

    def self.get_web_request_handler(request)
      nil
    end

  end
end
