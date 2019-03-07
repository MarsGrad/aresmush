module AresMUSH
  module L5R
    class FamilySortCmd
      include CommandHandler

      attr_accessor :clan_name

      def parse_args
        self.clan_name = downcase_arg(cmd.args)
      end

      def required_args
        [self.clan_name]
      end

      def handle
        family_list = Global.read_config('l5r', 'families')
        family_list = family_list.select { |a| a['clan'].downcase == self.clan_name }
        if (family_list.empty?)
          client.emit_failure t('l5r.invalid_ability_name')
          return
        end
        family_names = family_list.map { |a| "#{a['name']} -- #{a['clan']}"}

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
