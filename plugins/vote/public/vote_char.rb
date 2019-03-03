module AresMUSH
  class Character
    before_delete :delete_votes
    attribute :total_votes, :type => DataType::Integer, :default => 0

    def delete_votes
      votes_given.each { |c| c.delete }
    end

    def votes_received
      VoteAward.find(recipient_id: self.id)
    end

    def votes_given
      VoteAward.find(giver_id: self.id)
    end
  end
end
