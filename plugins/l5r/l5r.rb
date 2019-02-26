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
        if (cmd.switch_is?("init"))
          return SheetInitCmd
        else
          return SheetCmd
        end
      when "school"
        if (cmd.switch_is?("add"))
          return SchoolAddCmd
        elsif (cmd.switch_is?("rem"))
          return SchoolRemCmd
        else
          return SchoolCmd
        end
      when "tech"
        if (cmd.switch_is?("add"))
          return TechAddCmd
        elsif (cmd.switch_is?("rem"))
          return TechRemCmd
        else
          return TechCmd
        end
      when "spell"
        if (cmd.switch_is?("add"))
          return SpellAddCmd
        elsif (cmd.switch_is?("rem"))
          return SpellRemCmd
        else
          return SpellCmd
        end
      when "kata"
        if (cmd.switch_is?("add"))
          return KataAddCmd
        elsif (cmd.switch_is?("rem"))
          return KataRemCmd
        else
          return KataCmd
        end
      when "kiho"
        if (cmd.switch_is?("add"))
          return KihoAddCmd
        elsif (cmd.switch_is?("rem"))
          return KihoRemCmd
        else
          return KihoCmd
        end
      when "family"
        if (cmd.switch_is?("set"))
          return FamilySetCmd
        else
          return FamilyCmd
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
