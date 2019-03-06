module AresMUSH
  module L5R
    class TechSortCmd
      include CommandHandler

      attr_accessor :school_name

      def parse_args
        self.school_name = downcase_arg(cmd.args)
      end

      def required_args
        [self.school_name]
      end

      def handle
        tech_list = Global.read_config('l5r', 'techniques')
        tech_list = tech_list.select { |a| a['school'].downcase == self.school_name }
        if (tech_list.empty?)
          client.emit_failure t('l5r.invalid_ability_name')
          return
        end
        tech_names = tech_list.map { |a| "#{a['name']} -- #{a['school']}/#{a['rank']}" }

        list = spell_names.each_with_index.map do |a, i|
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
