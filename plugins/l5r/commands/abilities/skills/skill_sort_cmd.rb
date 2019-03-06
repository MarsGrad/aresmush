module AresMUSH
  module L5R
    class SkillSortCmd
      include CommandHandler

      attr_accessor :level_name

      def parse_args
        self.level_name = downcase_arg(cmd.args)
      end

      def required_args
        [self.level_name]
      end

      def handle
        skill_list = Global.read_config('l5r', 'skills')
        skill_list = skill_list.select { |a| a['level'].downcase == self.level_name }
        if (skill_list.empty?)
          client.emit_failure t('l5r.invalid_ability_name')
          return
        end
        skill_names = skill_list.map { |a| "#{a['name']} -- #{a['level']}"}

        list = skill_names.each_with_index.map do |a, i|
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
