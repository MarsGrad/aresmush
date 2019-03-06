module AresMUSH
  module L5R
    class ClanCmd
      include CommandHandler

      attr_accessor :clan_name

      def parse_args
        if (cmd.args)
          self.clan_name = downcase_arg(cmd.args)
        end
      end

      def handle
        if (!self.clan_name)
          clan_list = Global.read_config('l5r', 'clans')
          clan_names = clan_list.map { |t| "#{t['name']}"}

          list = clan_names.each_with_index.map do |a, i|
            linebreak = i % 2 == 0 ? "\n" : ""
            "#{linebreak}#{a}"
          end

          paginator = Paginator.paginate(list, cmd.page, 10)

          if (paginator.out_of_bounds?)
            client.emit_failure paginator.out_of_bounds_msg
          else
            template = OptionsListTemplate.new(paginator)
            client.emit template.render
          end
        else
          clan_config = L5R.find_clan_config(self.clan_name)

          if (!clan_config)
            client.emit_failure t('l5r.invalid_ability_name')
            return
          end

          template = ClanDisplayTemplate.new(clan_config)
          client.emit template.render
        end
      end
    end
  end
end
