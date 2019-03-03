module AresMUSH
  class VoteAward < Ohm::Model
    include ObjectModel

    reference :giver, "AresMUSH::Character"
    reference :recipient, "AresMUSH::Character"
  end
end
