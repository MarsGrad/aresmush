module AresMUSH
  class Character
    attribute :admin_name
    attribute :admin_name_upcase

    index :admin_name_upcase

    def save_upcase
      self.name_upcase = self.name ? self.name.upcase : nil
      self.alias_upcase = self.alias ? self.alias.upcase : nil
      self.admin_name_upcase = self.admin_name ? self.admin_name.upcase : nil
    end

    def self.find_any_by_name(name_or_id)
      return [] if !name_or_id

      if (name_or_id.start_with?("#"))
        return find_any_by_id(name_or_id)
      end

      find(name_upcase: name_or_id.upcase).union(alias_upcase: name_or_id.upcase).union(admin_name_upcase: name_or_id.upcase).to_a
    end
  end
end
