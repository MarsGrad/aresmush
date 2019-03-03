module AresMUSH
  module Vote
    class VotesCmd
      include CommandHandler

      def handle
        vote_recipients = enactor.votes_given
        if (vote_recipients.empty?)
          votes_given = t('vote.votes_not_given_this_week')
        else
          votes_given = vote_recipients.map { |c| c.recipient.name }.join(", ")
          votes_given = t('vote.votes_given_this_week', :votes => votes_given)
        end

        votes_total = t('vote.votes_total', :votes => enactor.total_votes)
        list = [ votes_given, "", votes_total ]
        template = BorderedListTemplate.new list
        client.emit template.render
      end
    end
  end
end
