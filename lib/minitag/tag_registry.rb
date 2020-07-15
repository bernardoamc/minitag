# frozen_string_literal: true

module Minitag
  # Stores tags associated with a test name, which belongs to a namespace.
  # The namespace is usually the class which the test belongs to.
  class TagRegistry
    def initialize
      @repository = Hash.new { |h, k| h[k] = Set.new }
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
      @repository[key(namespace, name)] = Set.new(tags)
    end

    # Fetches tags associated with a test name and namespace.
    #
    # @param [String] namespace the context which a test name belongs.
    # @param [String] name the test name.
    #
    # @return [Set] the tags associated with the specified namespace and test name.
    def fetch(namespace:, name:)
      @repository[key(namespace, name)]
    end

    private

    def key(namespace, name)
      "#{namespace}_#{name}"
    end
  end
end
