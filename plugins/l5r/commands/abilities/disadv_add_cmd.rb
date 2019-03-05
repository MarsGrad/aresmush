module AresMUSH
  module L5R
    class DisadvAddCmd
      include CommandHandler

      attr_accessor :target_name, :disadv_name, :descriptor

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_optional_arg3)
        self.target_name = titlecase_arg(args.arg1)
        self.disadv_name = titlecase_arg(args.arg2)
        self.descriptor = titlecase_arg(args.arg3)
      end

      def required_args
        [self.target_name, self.disadv_name]
      end

      def check_can_set
        return nil if L5R.can_manage_abilities?(enactor)
        return t('dispatcher.not_allowed')
      end

      def handle
        ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|

          disadv_config = L5R.find_disadvantage_config(self.disadv_name)
          if (!disadv_config)
            client.emit_failure t('l5r.invalid_ability_name')
            return
          end

          is_ranked = disadv_config['ranked']
          restriction = disadv_config['restriction']
          name = disadv_config['name']
          max_rank = disadv_config['max_rank']

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
            disadv = L5R.find_disadvantage(model, self.adv_name, self.descriptor)
          else
            disadv = L5R.find_disadvantage(model, self.adv_name)
          end

          if (disadv && !is_ranked)
            client.emit_failure t('l5r.not_ranked')
            return
          end

          if (disadv && is_ranked)
            if disadv.rank == max_rank
              client.emit_failure t('l5r.at_max_rank')
              return
            end
            disadv.update(rank: disadv.rank + 1)
          elsif (!disadv && self.descriptor)
            L5rDisadvantage.create(name: name.titlecase, descriptor: self.descriptor, rank: 1, character: model)
          else
            L5rDisadvantage.create(name: name.titlecase, rank: 1, character: model)
          end
          client.emit_success t('l5r.ability_added')
        end
      end
    end
  end
end
