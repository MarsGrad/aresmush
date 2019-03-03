module AresMUSH
  module Vote
    class VoteHereCmd
      include CommandHandler

      def handle
        client.emit_success t('vote.giving_votes_here')
        enactor_room.characters.each do |c|
          if (c != enactor && Login.is_online?(c))
            error = Vote.give_vote(c, enactor)
            if (error)
              client.emit_failure error
            else
              client.emit_success t('vote.vote_given', :name => c.name)
            end
          end
        end
      end
    end
  end
end
