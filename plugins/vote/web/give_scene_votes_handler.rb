module AresMUSH
  module Vote
    class GiveSceneVotesRequestHandler
      def handle(request)
        scene = Scene[request.args[:id]]
        enactor = request.enactor

        if (!scene)
          return { error: t('webportal.not_found') }
        end

        error = Website.check_login(request)
        return error if error

        Global.logger.debug "Scene #{scene.id} votes given by #{enactor.name}."

        scene.participants.each do |c|
          if (c != enactor)
            Vote.give_vote(c, enactor)
          end
        end

        {
        }
      end
    end
  end
end
