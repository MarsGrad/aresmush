module AresMUSH
  module L5R
    class AdvAddCmd
      include CommandHandler

      attr_accessor :target_name, :adv_name, :descriptor

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_optional_arg3)
        self.target_name = titlecase_arg(args.arg1)
        self.adv_name = titlecase_arg(args.arg2)
        self.descriptor = titlecase_arg(args.arg3)
      end

      def required_args
        [self.target_name, self.adv_name]
      end

      def check_can_set
        return nil if L5R.can_manage_abilities?(enactor)
        return t('dispatcher.not_allowed')
      end

      def handle
        ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|

          adv_config = L5R.find_advantage_config(self.adv_name)
          if (!adv_config)
            client.emit_failure t('l5r.invalid_ability_name')
            return
          end

          is_ranked = adv_config['is ranked']
          restriction = adv_config['restriction']
          name = adv_config['name']
          is_disadvantage = adv_config['disadvantage']
          max_rank = adv_config['max_rank']

          if restriction.include?("descriptor")
            if (!self.descriptor)
              client.emit_failure t('l5r.needs_descriptor')
              return
            end
          end

          if restriction.include?("note")
            client.emit_ooc t('l5r.needs_note')
          end

          if (self.descriptor)
            adv = L5R.find_advantage(model, self.adv_name, self.descriptor)
          else
            adv = L5R.find_advantage(model, self.adv_name)
          end

          adv = ""

          if (adv.empty? && is_ranked == false)
            client.emit_failure t('l5r.not_ranked')
            return
          end

          if (adv.empty? && is_ranked == true)
            if adv.rank == max_rank
              client.emit_failure t('l5r.at_max_rank')
              return
            end
            adv.update(rank: adv.rank + 1)
          elsif (adv.empty? && self.descriptor)
            L5rAdvantage.create(name: name.titlecase, descriptor: self.descriptor.titlecase, rank: 1, disadvantage?: is_disadvantage, character: model)
          else
            L5rAdvantage.create(name: name.titlecase, rank: 1, disadvantage?: is_disadvantage, character: model)
          end
          client.emit_success t('l5r.ability_added')
        end
      end
    end
  end
end
