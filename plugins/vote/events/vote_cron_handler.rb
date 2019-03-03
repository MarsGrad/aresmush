module AresMUSH
  module Vote
    class CronEventHandler
      def on_event(event)
        config = Global.read_config("vote", "vote_award_cron")
        return if !Cron.is_cron_match?(config, event.time)

        Global.logger.debug "Issuing votes."

        votes_per_xp = Global.read_config("vote", "votes_per_xp")

        awards = ""
        counts = {}
        VoteAward.all.each do |c|
          recipient = c.recipient
          if (counts.has_key?(c.recipient))
            counts[recipient] = counts[recipient] + 1
          else
            counts[recipient] = 1
          end
          c.delete
        end

        counts.sort_by { |char, count| count }.reverse.each_with_index do |(char, count), i|
          index = i+1
          if (i <= 10)
            num = "#{index.to_s}."
            awards << "#{num.ljust(3)} #{char.name.ljust(20)}#{count}\n"
          end

          if (votes_per_xp != 0)
            xp = count.to_f / votes_per_xp
            char.award_xp(xp)
          end

          char.update(total_votes: char.total_votes + count)

          end

        end

        return if awards.blank?
        
    end
  end
end
