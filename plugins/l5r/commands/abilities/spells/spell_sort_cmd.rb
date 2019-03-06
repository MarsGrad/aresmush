module AresMUSH
  module L5R
    class SpellSortCmd
      include CommandHandler

      attr_accessor :ring_name

      def parse_args
        self.ring_name = downcase_arg(cmd.args)
      end

      def required_args
        [self.ring_name]
      end

      def handle
        spell_list = Global.read_config('l5r', 'spells')
        spell_list = spell_list.select { |a| a['ring'].downcase == self.subtype_name }
        if (spell_list.empty?)
          client.emit_failure t('l5r.invalid_ability_name')
          return
        end
        spell_names = spell_list.map { |a| "#{a['name']} -- #{a['ring']}/#{a['mastery']}"}

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
