module AresMUSH
  module L5R
    class KihoSortCmd
      include CommandHandler

      attr_accessor :sort_name

      def parse_args
        self.sort_name = downcase_arg(cmd.args)
      end

      def required_args
        [self.sort_name]
      end

      def handle
        kiho_list = Global.read_config('l5r', 'kiho')
        kiho_ring_list = kiho_list.select { |a| a['ring'].downcase == self.sort_name }
        kiho_type_list = kiho_list.select { |a| a['type'].downcase == self.sort_name }
        if (kiho_ring_list.empty? && kiho_type_list.empty?)
          client.emit_failure t('l5r.invalid_ability_name')
          return
        end
        if (!kiho_ring_list.empty?)
          kiho_names = kiho_ring_list.map { |a| "#{a['name']} -- #{a['ring']}/#{a['mastery']}"}
        elsif (!kiho_type_list.empty?)
          kiho_names = kiho_type_list.map { |a| "#{a['name']} -- #{a['type']}/#{a['mastery']}"}
        end

        list = kiho_names.each_with_index.map do |a, i|
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
