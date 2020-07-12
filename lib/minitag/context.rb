# frozen_string_literal: true

require 'set'
require_relative './tag_registry'

module Minitag
  # Represents the execution context of the test suite.
  class Context
    def initialize
      @inclusive_filters = Set.new
      @exclusive_filters = Set.new
      @tag_registry = Minitag::TagRegistry.new
    end

    # Associates tags with a name taking into account its namespace.
    #
    # @param [String] namespace the namespace which a name belongs.
    # @param [String] name the test name.
    # @param [Array] tags the collection of tags.
    #
    # @return [void]
    def add_tags(namespace:, name:, tags:)
      @tag_registry.add(namespace: namespace, name: name, tags: tags)
    end

    # Adds a filter tag.
    # Tags with a ~ prefix are exclusive filters and inclusive filters otherwise.
    #
    # param [String] name the name of the filter tag.
    #
    # Invariants:
    #   - A filter will always be a String without the ~ prefix.
    #
    # @return [void]
    def add_filter(tag)
      if tag.start_with?('~')
        @exclusive_filters << tag[1..]
      else
        @inclusive_filters << tag
      end
    end

    # Indicates when a context has no filters.
    #
    # @return [boolean] whether a context has no filters.
    def no_filters?
      @inclusive_filters.empty? && @exclusive_filters.empty?
    end

    # Detects whether the name associated with a namespace contains tags
    # that matches the filtering criteria.
    #
    # @param [String] namespace the namespace which a test name belongs.
    # @param [String] name the test name.
    #
    # Invariants:
    #   - Returns true when no filters are present.
    #
    # return [boolean] whether there was a match or not.
    def match?(namespace:, name:)
      return true if no_filters?

      tags = @tag_registry.fetch(namespace: namespace, name: name)
      match_inclusive_filters?(tags) && match_exclusive_filters?(tags)
    end

    private

    # Detects whether any of the tags matches the inclusive filters.
    #
    # @param [Set] tags the set of tags.
    #
    # Invariants:
    #   - Returns true when no inclusive filters are specified.
    #   - Returns false when inclusive filters are specified but there
    #     are no tags.
    #
    # return [boolean] whether there was a match or not.
    def match_inclusive_filters?(tags)
      return true if @inclusive_filters.empty?
      return false if @inclusive_filters.any? && tags.empty?

      (@inclusive_filters & tags).any?
    end

    # Detects whether any of the tags matches the exclusive filters.
    #
    # @param [Set] tags the set of tags.
    #
    # Invariants:
    #   - Returns true when no exclusive filters are specified.
    #   - Returns true when exclusive filters are specified and there
    #     are no tags.
    #
    # return [boolean] whether there was a match or not.
    def match_exclusive_filters?(tags)
      return true if @exclusive_filters.empty?
      return true if @exclusive_filters.any? && tags.empty?

      (@exclusive_filters & tags).none?
    end
  end
end
