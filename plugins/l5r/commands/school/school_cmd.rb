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

        template = BorderedPagedListTemplate.new(list, cmd.page, 10, t("l5r.school_list_title"))
        client.emit template.render
      end
    end
  end
end
