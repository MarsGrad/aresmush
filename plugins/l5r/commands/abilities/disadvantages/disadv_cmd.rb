module AresMUSH
  module L5R
    class DisadvCmd
      include CommandHandler

      attr_accessor :disadv_name

      def parse_args
        if (cmd.args)
          self.disadv_name = downcase_arg(cmd.args)
        end
      end

      def handle
        if (!self.disadv_name)
          disadv_list = Global.read_config('l5r', 'disadvantages')
          disadv_names = disadv_list.map { |t| "#{t['name']} -- #{t['subtype']}"}

          list = disadv_names.each_with_index.map do |a, i|
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
          disadv_config = L5R.find_disadvantage_config(self.disadv_name)

          if (!disadv_config)
            client.emit_failure t('l5r.invalid_ability_name')
            return
          end

          template = DisadvDisplayTemplate.new(disadv_config)
          client.emit template.render
        end
      end
    end
  end
end
