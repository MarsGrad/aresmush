module AresMUSH
  module L5R
    class KataCmd
      include CommandHandler

      attr_accessor :kata_name

      def parse_args
        if (cmd.args)
          self.kata_name = downcase_arg(cmd.args)
        end
      end

      def handle
        if (!self.kata_name)
          kata_list = Global.read_config('l5r', 'kata')
          kata_names = kata_list.map { |t| "#{t['name']} -- #{t['ring']}"}

          list = kata_names.each_with_index.map do |a, i|
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
          kata_config = L5R.find_kata_config(self.kata_name)

          if (!kata_config)
            client.emit_failure t('l5r.invalid_ability_name')
            return
          end

          template = KataDisplayTemplate.new(kata_config)
          client.emit template.render
        end
      end
    end
  end
end
