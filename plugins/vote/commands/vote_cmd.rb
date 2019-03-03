module AresMUSH
  module Vote
    class VoteCmd
      include CommandHandler

      attr_accessor :names

      def parse_args
        if (!cmd.args)
          self.names = []
        else
          self.names = cmd.args.split(" ")
        end
      end

      def handle
        names.each do |name|
          result = ClassTargetFinder.find(name, Character, enactor)
          if (!result.found?)
            client.emit_failure(t('vote.invalid_recipient', :name => name))
          else
            error = Vote.give_vote(result.target, enactor)
            if (error)
              client.emit_failure error
            else
              client.emit_success t('vote.vote_given', :name => name)
            end
          end
        end
      end
    end
  end
end
