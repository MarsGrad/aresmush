module AresMUSH
  module L5R
    class KihoCmd
      include CommandHandler

      attr_accessor :kiho_name

      def parse_args
        if (cmd.args)
          self.kiho_name = downcase_arg(cmd.args)
        end
      end

      def handle
        if (!self.kiho_name)
          kiho_list = Global.read_config('l5r', 'kiho')
          kiho_names = kiho_list.map { |t| "#{t['name']} -- #{t['ring']}/#{t['mastery']}"}

          list = kiho_names.each_with_index.map do |a, i|
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
          kiho_config = L5R.find_kiho_config(self.kiho_name)

          if (!kiho_config)
            client.emit_failure t('l5r.invalid_ability_name')
            return
          end

          template = KihoDisplayTemplate.new(kiho_config)
          client.emit template.render
        end
      end
    end
  end
end
