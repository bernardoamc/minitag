# frozen_string_literal: true

module Minitag
  # Stores tags associated with a namespace or a single test case.
  #
  # A namespace is usually the class which tests belongs to.
  class TagRegistry
    def initialize
      @registry = {}
    end

    # Associates tags with a name taking into account its namespace.
    #
    # Duplicated tags will be removed during this operation.
    #
    # @param [String] namespace the context which a test name belongs.
    # @param [String] name the test name.
    # @param [Array] tags the collection of tags associated with a test.
    #
    # @return [void]
    def add(namespace:, name:, tags:)
      @registry[key(namespace, name)] = Set.new(tags)
    end

    # Associates tags with a namespace.
    #
    # Duplicated tags will be removed during this operation.
    #
    # @param [String] namespace the context which a test name belongs.
    # @param [Array] tags the collection of tags associated with a test.
    #
    # @return [void]
    def add_for_namespace(namespace:, tags:)
      @registry[namespace] = Set.new(tags)
    end

    # Fetches tags associated with a test name and namespace.
    #
    # @param [String] namespace the context which a test name belongs.
    # @param [String] name the test name.
    #
    # @return [Set] the tags associated with the specified namespace and test name.
    def get(namespace:, name:)
      @registry.fetch(namespace, Set.new).union(
        @registry.fetch(key(namespace, name), Set.new)
      )
    end

    private

    def key(namespace, name)
      "#{namespace}_#{name}"
    end
  end
end
