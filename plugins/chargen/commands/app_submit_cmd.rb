module AresMUSH
  module Chargen
    class AppSubmitCmd
      include L5R
      include CommandHandler

      attr_accessor :app_notes

      def parse_args
        self.app_notes = cmd.args
      end

      def check_approval
        return t('chargen.you_are_already_approved') if enactor.is_approved?
        return nil
      end

      def handle
        school = enactor.l5r_current_school
        school_config = L5R.find_school_config(school)
        skill_choice = school_config['skill_choice']
        spell_choice = school_config['spell_choice']
        choice = ""
        if (skill_choice)
          choice << "Skill Choice: #{skill_choice}%r"
        end
        if (spell_choice)
          choice << "Spell Choice: #{spell_choice}%r"
        end

        if (cmd.switch_is?("confirm"))
          client.emit_success Chargen.submit_app(enactor, client.program[:app_notes], choice)
          client.emit_ooc t('chargen.approval_reminder')
        else
          client.program[:app_notes] = self.app_notes
          client.emit_ooc t('chargen.app_confirm')
        end
      end
    end
  end
end
