module AresMUSH
  module L5R
    class StanceCmd
      include CommandHandler

      attr_accessor :stance_name

      def parse_args
        self.stance_name = downcase_arg(cmd.args)
      end

      def required_args
        [self.stance_name]
      end

      def handle
        stance = self.stance_name
        if stance != "attack" && stance != "defense" && stance != "full defense" && stance != "full attack" && stance != "center"
          client.emit_failure t('l5r.invalid_stance')
          return
        end

        enactor.update(l5r_stance: stance)
        Room.emit_ooc_to_room enactor_room, t('l5r.stance_change, :character => enactor_name, :stance => stance.titlecase)
      end
    end
  end
end
