module AresMUSH
  module L5R
    class SchoolCmd
      include CommandHandler

      attr_accessor :school_name

      def parse_args
        if (cmd.args)
          self.school_name = downcase_arg(cmd.args)
        end
      end

      def handle
        if (!self.school_name)
          school_list = Global.read_config('l5r', 'schools')
          school_names = school_list.map { |s| "#{s['name']} -- #{s['clan']}" }

          list = school_names.each_with_index.map do |a, i|
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
          school_config = L5R.find_school_config(self.school_name)

          if (!school_config)
            client.emit_failure t('l5r.invalid_school')
            return
          end

          template = SchoolDisplayTemplate.new(school_config, "Schools")
          client.emit template.render
        end
      end
    end
  end
end
