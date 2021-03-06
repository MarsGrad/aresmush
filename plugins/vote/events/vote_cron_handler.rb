module AresMUSH
  module Vote
    class CronEventHandler
      include L5R
      
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
            L5R.award_xp(char, xp)
          end

          char.update(total_votes: char.total_votes + count)

          end

        end
    end
  end
end
