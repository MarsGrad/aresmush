module AresMUSH
  module L5R
    class XpCronHandler
      def on_event(event)
        config = Global.read_config("l5r", "xp_cron")
        return if !Cron.is_cron_match?(config, event.time)

        Global.logger.debug "XP awards."

        periodic_xp = Global.read_config("l5r", "periodic_xp")

        approved = Chargen.approved_chars
        approved.each do |a|
          L5R.award_xp(a, periodic_xp)
        end
      end
    end
  end
end
