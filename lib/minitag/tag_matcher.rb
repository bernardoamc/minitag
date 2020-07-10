module Minitag
  class TagMatcher
    def self.inclusive_match?(desired_tags, existing_tags)
      return true if desired_tags.empty?
      return false if desired_tags.any? && existing_tags.empty?

      (desired_tags & existing_tags).any?
    end

    def self.exclusive_match?(desired_tags, existing_tags)
      return true if desired_tags.empty?
      return true if desired_tags.any? && existing_tags.empty?

      (desired_tags & existing_tags).none?
    end
  end
end
