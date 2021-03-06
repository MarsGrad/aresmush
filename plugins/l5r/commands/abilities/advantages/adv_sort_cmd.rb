module AresMUSH
  module L5R
    class AdvSortCmd
      include CommandHandler

      attr_accessor :subtype_name

      def parse_args
        self.subtype_name = downcase_arg(cmd.args)
      end

      def required_args
        [self.subtype_name]
      end

      def handle
        adv_list = Global.read_config('l5r', 'advantages')
        adv_list = adv_list.select { |a| a['subtype'].downcase == self.subtype_name }
        if (adv_list.empty?)
          client.emit_failure t('l5r.invalid_ability_name')
          return
        end
        adv_names = adv_list.map { |a| "#{a['name']} -- #{a['subtype']}"}

        list = adv_names.each_with_index.map do |a, i|
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
