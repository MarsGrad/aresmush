module AresMUSH
  module L5R
    class SchoolDisplayTemplate < ErbTemplateRenderer
      attr_accessor :school_config

      def initialize(school_config)
        @school_config = school_config
        super File.dirname(__FILE__) + "/school_display.erb"
      end

      def name_clan
        name = school_config['name']
        clan = school_config['clan']
        display = left("%xyName%xn: #{name}", 30)
        display << "%xyClan%xn: #{clan}"
        display
      end

      def trait
        trait = school_config['trait_bonus']
        display = "%xyTrait Bonus%xn: #{trait}"
        display
      end

      def skills
        skills = school_config['skills']
        skill_choice = school_config['skill_choice']
        skills = skills.join(", ")
        display = "%xySkills%xn: #{skills}, and #{skill_choice}"
        display
      end

      def honor
        honor = school_config['honor']
        display = "%xyHonor%xn: %xr#{honor}%xn"
        display
      end

      def techniques
        techs = school_config['techniques']
        first = techs.shift(3)

        display = "%xyTechniques%xn: "
        display << first.join(", ")
        display << "%r"
        display << techs.join(", ")

        display
      end

      def starting_tech
        tech = school_config['starting_technique']
        display = "%xyTechnique%xn: #{tech}"
        display
      end

      def affinity_deficiency
        affinity = school_config['affinity']
        deficiency = school_config['deficiency']
        display = left("%xyAffinity%xn: #{affinity}", 30)
        display << "%xyDeficiency%xn: #{deficiency}"
        display
      end

      def spells
        spells = school_config['spells']
        display = "%xyStarting Spells%xn: #{spells}"
        display
      end
    end
  end
end
