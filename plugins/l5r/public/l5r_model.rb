module AresMUSH
  class Character < Ohm::Model
    collection :l5r_skills, "AresMUSH::L5rSkill"
    collection :l5r_advantages, "AresMUSH::L5rAdvantage"
    collection :l5r_spells, "AresMUSH::L5rSpell"
    collection :l5r_traits, "AresMUSH::L5rTrait"
    collection :l5r_techniques, "AresMUSH::L5rTechnique"
    collection :l5r_kata, "AresMUSH::L5rKata"
    collection :l5r_kiho, "AresMUSH::L5rKiho"
    collection :l5r_schools, "AresMUSH::L5rSchool"

    attribute :l5r_family
    attribute :l5r_clan
    attribute :l5r_void_ring, :type => DataType::Integer
    attribute :l5r_insight_rank, :type => DataType::Integer
    attribute :l5r_void_pool, :type => DataType::Integer
    attribute :l5r_mastery_rank, :type => DataType::Integer

    before_delete :delete_l5r_abilities

    def delete_l5r_abilities
      [ self.l5r_skills, self.l5r_advantages, self.l5r_spells,
        self.l5r_techniques, self.l5r_kata, self.l5r_kiho, self.l5r_schools ].each do |list|
          list.each do |a|
            a.delete
          end
        end
      end
    end

    class L5rTrait < Ohm::Model
      include ObjectModel

      attribute :name
      attribute :rank, :type => DataType::Integer
      reference :character, "AresMUSH::Character"
      index :name
    end

    class L5rSkill < Ohm::Model
      include ObjectModel

      attribute :name
      attribute :rank, :type => DataType::Integer
      reference :character, "AresMUSH::Character"
      attribute :emphases, :type => DataType::Hash, :default => {}
      index :name
    end

    class L5rAdvantage < Ohm::Model
      include ObjectModel

      attribute :name
      attribute :rank, :type => DataType::Integer
      attribute :disadvantage?, :type => DataType::Boolean
      reference :character, "AresMUSH::Character"
      index :name
    end

    class L5rSpell < Ohm::Model
      include ObjectModel

      attribute :name
      attribute :rank, :type => DataType::Integer
      reference :character, "AresMUSH::Character"
      index :name
    end

    class L5rTechnique < Ohm::Model
      include ObjectModel

      attribute :name
      attribute :rank, :type => DataType::Integer
      reference :character, "AresMUSH::Character"
      index :name
    end

    class L5rKata < Ohm::Model
      include ObjectModel

      attribute :name
      attribute :rank, :type => DataType::Integer
      reference :character, "AresMUSH::Character"
      index :name
    end

    class L5rKiho < Ohm::Model
      include ObjectModel

      attribute :name
      attribute :rank, :type => DataType::Integer
      reference :character, "AresMUSH::Character"
      index :name
    end

    class L5rSchool < Ohm::Model
      include ObjectModel

      attribute :name
      attribute :rank, :type => DataType::Integer
      reference :character, "AresMUSH::Character"
      index :name
    end
  end
