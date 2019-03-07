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
      when "xp"
        case cmd.switch
        when "award"
          return XPAwardCmd
        when "spend"
          return XPSpendCmd
        else
          if (!cmd.switch)
            return XPCmd
          end
        end
      when "roll"
        case cmd.switch
        when "emphasis"
          return RollEmpCmd
        when "unskilled"
          return RollUnskCmd
        when "affinity"
          return RollAffCmd
        when "deficiency"
          return RollDefCmd
        else
          if (!cmd.switch)
            return RollCmd
          end
        end
      when "void"
        case cmd.switch
        when "burn"
          return VoidBurnCmd
        when "recover"
          return VoidRecoverCmd
        end
      when "ad"
        case cmd.switch
        when "set"
          return ADSetCmd
        end
      when "trait"
        case cmd.switch
        when "raise"
          return TraitRaiseCmd
        when "lower"
          return TraitLowerCmd
        end
      when "skill"
        case cmd.switch
        when "raise"
          return SkillRaiseCmd
        when "lower"
          return SkillLowerCmd
        when "sort"
          return SkillSortCmd
        else
          if (!cmd.switch)
            return SkillCmd
          end
        end
      when "adv"
        case cmd.switch
        when "add"
          return AdvAddCmd
        when "rem"
          return AdvRemCmd
        when "sort"
          return AdvSortCmd
        else
          if (!cmd.switch)
            return AdvCmd
          end
        end
      when "disadv"
        case cmd.switch
        when "add"
          return DisadvAddCmd
        when "rem"
          return DisadvRemCmd
        when "sort"
          return DisadvSortCmd
        else
          if (!cmd.switch)
            return DisadvCmd
          end
        end
      when "sheet"
        case cmd.switch
        when "init"
          return SheetInitCmd
        when "set"
          return SheetSetCmd
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
        when "add"
          return SchoolAddCmd
        when "sort"
          return SchoolSortCmd
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
        when "sort"
          return TechSortCmd
        else
          if (!cmd.switch)
            return TechCmd
          end
        end
      when "spell"
        case cmd.switch
        when "add"
          return SpellAddCmd
        when "rem"
          return SpellRemCmd
        when "burn"
          return SpellBurnCmd
        when "recover"
          return SpellRecoverCmd
        when "sort"
          return SpellSortCmd
        else
          if (!cmd.switch)
            return SpellCmd
          end
        end
      when "kata"
        case cmd.switch
        when "add"
          return KataAddCmd
        when "rem"
          return KataRemCmd
        when "sort"
          return KataSortCmd
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
        when "sort"
          return KihoSortCmd
        else
          if (!cmd.switch)
            return KihoCmd
          end
        end
      when "family"
        case cmd.switch
        when "set"
          return FamilySetCmd
        when "rem"
          return FamilyRemCmd
        when "sort"
          return FamilySortCmd
        else
          if (!cmd.switch)
            return FamilyCmd
          end
        end
      when "clan"
        case cmd.switch
        when "set"
          return ClanSetCmd
        when "rem"
          return ClanRemCmd
        else
          if (!cmd.switch)
            return ClanCmd
          end
        end
      when "stance"
        return StanceCmd
      when "prove"
        case cmd.switch
        when "to"
          return ProveToCmd
        else
          if (!cmd.switch)
            return ProveCmd
          end
        end
      when "wounds"
        case cmd.switch
        when "add"
          return WoundsAddCmd
        when "heal"
          return WoundsHealCmd
        else
          if (!cmd.switch)
            return WoundsCmd
          end
        end
      end

      return nil
    end

    def self.get_event_handler(event_name)
      case event_name
      when "CronEvent"
        return L5rXpCronHandler
      end

      nil
    end

    def self.get_web_request_handler(request)
      nil
    end

  end
end
