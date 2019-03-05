module AresMUSH
  module L5R
    class SchoolDisplayTemplate < ErbTemplateRenderer
      attr_accessor :school_name, :school_config

      def initialize(school_name)
        @school_name = school_name
        @school_config = L5R.find_school_config(school_name)
        super File.dirname(__FILE__) + "/school_display.erb"
      end

      def name_clan
        name = school_config['name']
        clan = school_config['clan']
        display = left("Name: #{name}", 30)
        display << "Clan: #{clan}"
        display
      end

      def trait
        trait = school_config['trait_bonus']
        display = "Trait Bonus: #{trait}"
        display
      end

      def skills
        skills = school_config['skills']
        skill_choice = school_config['skill_choice']
        skills = skills.join(", ")
        display = "Skills: #{skills}, and #{skill_choice}"
        display
      end

      def honor
        honor = school_config['honor']
        display = "Honor: #{honor}"
        display
      end

      def techniques
        techs = school_config['techniques']
        first = techs.shift(3)

        display = "Techniques: "
        display << first.join(", ")
        display << "%r"
        display << techs.join(", ")

        display
      end

      def starting_tech
        tech = school_config['starting_technique']
        display = "Technique: #{tech}"
        display
      end

      def affinity_deficiency
        affinity = school_config['affinity']
        deficiency = school_config['deficiency']
        display = left("Affinity: #{affinity}", 30)
        display << "Deficiency: #{deficiency}"
        display
      end

      def spells
        spells = school_config['spells']
        display = "Starting Spells: #{spells}"
        display
      end
    end
  end
end
