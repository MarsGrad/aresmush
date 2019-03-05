module AresMUSH
  module L5R
    class SchoolSortCmd
      include CommandHandler

      attr_accessor :clan_name

      def parse_args
        self.clan_name = downcase_arg(cmd.args)
      end

      def required_args
        [self.clan_name]
      end

      def handle
        school_list = Global.read_config('l5r', 'schools')
        school_list = school_list.select { |s| s['clan'].downcase == self.clan_name }
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
      end
    end
  end
end
