module AresMUSH
  module L5R
    class SkillCmd
      include CommandHandler

      attr_accessor :skill_name

      def parse_args
        if (cmd.args)
          self.skill_name = downcase_arg(cmd.args)
        end
      end

      def handle
        if (!self.skill_name)
          skill_list = Global.read_config('l5r', 'skills')
          skill_names = skill_list.map { |t| "#{t['name']} -- #{t['level']}"}

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
        else
          skill_config = L5R.find_skill_config(self.skill_name)

          if (!skill_config)
            client.emit_failure t('l5r.invalid_ability_name')
            return
          end

          template = SkillDisplayTemplate.new(skill_config)
          client.emit template.render
        end
      end
    end
  end
end
