module AresMUSH
  module L5R
    class AdvCmd
      include CommandHandler

      attr_accessor :adv_name

      def parse_args
        if (cmd.args)
          self.adv_name = downcase_arg(cmd.args)
        end
      end

      def handle
        if (!self.adv_name)
          adv_list = Global.read_config('l5r', 'advantages')
          adv_names = adv_list.map { |t| "#{t['name']} -- #{t['subtype']}"}

          list = adv_names.each_with_index.map do |a, i|
            linebreak = i % 2 == 0 ? "\n" : ""
            if i == 0
              "#{a}"
            else
              "#{linebreak}#{a}"
            end
          end

          paginator = Paginator.paginate(list, cmd.page, 10)

          if (paginator.out_of_bounds?)
            client.emit_failure paginator.out_of_bounds_msg
          else
            template = OptionsListTemplate.new(paginator)
            client.emit template.render
          end
        else
          adv_config = L5R.find_advantage_config(self.adv_name)

          if (!adv_config)
            client.emit_failure t('l5r.invalid_ability_name')
            return
          end

          template = AdvDisplayTemplate.new(adv_config)
          client.emit template.render
        end
      end
    end
  end
end
