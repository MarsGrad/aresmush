module AresMUSH
  module L5R
    class SchoolCmd
      include CommandHandler

      attr_accessor :school_name

      def parse_args
        if (cmd.args)
          self.school_name = trim_args(cmd.args)
        end
      end

      def handle
        school_list = Global.read_config('l5r', 'schools')
        school_names = school_list.map { |s| "#{s['name']} -- #{s['clan']}" }

        list = school_names.each_with_index.map do |a, i|
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
      end
    end
  end
end
