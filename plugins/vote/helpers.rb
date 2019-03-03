module AresMUSH
  module Vote
    def self.give_vote(recipient, giver)

      if (recipient == giver)
        return t('vote.cant_vote_yourself')
      end

      votes_from_giver = recipient.votes_received.select { |c| c.giver == giver }
      if (!votes_from_giver.empty?)
        return t('vote.vote_already_given', :name => recipient.name)
      end

      VoteAward.create(giver: giver, recipient: recipient)

      Login.emit_ooc_if_logged_in(recipient,  t('vote.vote_received', :name => giver.name))

      Global.logger.info "#{giver.name} voted for #{recipient.name}."

      return nil
    end
  end
end
