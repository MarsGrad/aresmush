module AresMUSH
  module Chargen
    class AppSubmitCmd
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
        skills = school_config['skills_display']
        spells = school_config['spells']
        aff_def_choice = school_config['aff_def_choice']
        sheet_type = enactor.l5r_sheet_type
        choice = ""
        if (skills)
          choice << "%r%xrSkills%xn: #{skills}"
        end
        if (spells)
          choice << "%r%xrSpells:%xn #{spells}"
        end
        if (aff_def_choice)
          choice << "%r%xrNOTE:%xn Affinity and Deficiency need to be chosen."
        end
        if (sheet_type == "monk")
          kiho_num = school_config['kiho_num']
          choice << "%r%xrNumber of Kiho:%xn #{kiho_num}"
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
