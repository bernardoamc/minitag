# frozen_string_literal: true

module Minitag
  # Introduce different match? methods based on the type of the chosen tags.
  class TagMatcher
    # Detects if any of the desired tags match any of the existing ones.
    #
    # @param [Array] desired_tags the tags specified by `--tag`.
    # @param [Array] existing_tags the tags specified by the `tag` method.
    #
    # Invariants:
    #   - Always returns true when no desired tags are specified.
    #   - Always returns false when desired tags are specified but there are
    #     no existing tags.
    #
    # return [boolean] whether there was a match or not.
    def self.inclusive_match?(desired_tags, existing_tags)
      return true if desired_tags.empty?
      return false if desired_tags.any? && existing_tags.empty?

      (desired_tags & existing_tags).any?
    end

    # Detects if there are no matches between any of the desired tags
    # and existing ones.
    #
    # @param desired_tags  [Array] tags specified by `--tag`.
    # @param existing_tags [Array] tags specified by the `tag` method.
    #
    # Invariants:
    #   - Always returns true when no desired tags are specified.
    #   - Always returns true when desired tags are specified but there are
    #     no existing tags.
    #
    # return [boolean] whether there was no match or not.
    def self.exclusive_match?(desired_tags, existing_tags)
      return true if desired_tags.empty?
      return true if desired_tags.any? && existing_tags.empty?

      (desired_tags & existing_tags).none?
    end
  end
end
