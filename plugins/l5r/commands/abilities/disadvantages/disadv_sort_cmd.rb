module AresMUSH
  module L5R
    class DisadvSortCmd
      include CommandHandler

      attr_accessor :subtype_name

      def parse_args
        self.subtype_name = downcase_arg(cmd.args)
      end

      def required_args
        [self.subtype_name]
      end

      def handle
        disadv_list = Global.read_config('l5r', 'disadvantages')
        disadv_list = disadv_list.select { |a| a['subtype'].downcase == self.subtype_name }
        if (disadv_list.empty?)
          client.emit_failure t('l5r.invalid_ability_name')
          return
        end
        disadv_names = disadv_list.map { |a| "#{a['name']} -- #{a['subtype']}"}

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
      end
    end
  end
end
