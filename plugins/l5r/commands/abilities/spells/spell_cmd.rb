module AresMUSH
  module L5R
    class SpellCmd
      include CommandHandler

      attr_accessor :spell_name

      def parse_args
        if (cmd.args)
          self.spell_name = downcase_arg(cmd.args)
        end
      end

      def handle
        if (!self.spell_name)
          spell_list = Global.read_config('l5r', 'spells')
          spell_names = spell_list.map { |t| "#{t['name']} -- #{t['ring']}/#{t['mastery']}"}

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
        else
          spell_config = L5R.find_spell_config(self.spell_name)

          if (!spell_config)
            client.emit_failure t('l5r.invalid_ability_name')
            return
          end

          template = SpellDisplayTemplate.new(spell_config)
          client.emit template.render
        end
      end
    end
  end
end
