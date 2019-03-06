module AresMUSH
  module L5R
    class TechCmd
      include CommandHandler

      attr_accessor :tech_name

      def parse_args
        if (cmd.args)
          self.tech_name = downcase_arg(cmd.args)
        end
      end

      def handle
        if (!self.tech_name)
          tech_list = Global.read_config('l5r', 'techniques')
          tech_names = tech_list.map { |t| "#{t['name']} -- #{s['school']}"}

          list = tech_names.each_with_index.map do |a, i|
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
          tech_config = L5R.find_tech_config(self.tech_name)

          if (!tech_config)
            client.emit_failure t('l5r.invalid_ability_name')
            return
          end

          template = TechDisplayTemplate.new(tech_config)
          client.emit template.render
        end
      end
    end
  end
end
