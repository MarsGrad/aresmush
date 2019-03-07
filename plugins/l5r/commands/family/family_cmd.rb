module AresMUSH
  module L5R
    class FamilyCmd
      include CommandHandler

      attr_accessor :family_name

      def parse_args
        if (cmd.args)
          self.family_name = downcase_arg(cmd.args)
        end
      end

      def handle
        if (!self.family_name)
          family_list = Global.read_config('l5r', 'families')
          family_names = family_list.map { |t| "#{t['name']} -- #{t['clan']}"}

          list = family_names.each_with_index.map do |a, i|
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
          family_config = L5R.find_family_config(self.family_name)

          if (!family_config)
            client.emit_failure t('l5r.invalid_ability_name')
            return
          end

          template = FamilyDisplayTemplate.new(family_config)
          client.emit template.render
        end
      end
    end
  end
end
