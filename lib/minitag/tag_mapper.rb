# frozen_string_literal: true

module Minitag
  # Stores the mapping between a test name and its existing tags.
  class TagMapper
    def initialize
      @repository = Hash.new { |h, k| h[k] = [] }
    end

    # Associates a tag with a test name takinto into account is context.
    #
    # @param [String] context the context which a test name belongs.
    # @param [String] name the test name.
    # @param [String] tag the tag name.
    #
    # @return [void]
    def add(context:, name:, tag:)
      @repository[key(context, name)] << Minitag::Tag.new(tag)
    end

    # Fetches tags associated with a test name and context.
    #
    # @param [String] context the context which a test name belongs.
    # @param [String] name the test name.
    #
    # @return [Array] the tags associated with the test.
    def fetch(context:, name:)
      @repository[key(context, name)]
    end

    private

    def key(context, name)
      "#{context}_#{name}"
    end
  end
end
