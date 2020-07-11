# frozen_string_literal: true

module Minitag
  # Represents a tag in our system.
  # Provides helper methods to identify the type of a tag, which can
  # only one of the following:
  #   - inclusive
  #   - exclusive (name with ~ as a prefix)
  class Tag
    attr_reader :name

    # Initializes a tag. Tags with a ~ prefix are deemed exclusive and
    # inclusive otherwise.
    #
    # param [String] name the name of the tag
    #
    # Invariants:
    #   - A tag name will always be a String without the ~ prefix
    #     after initialization.
    def initialize(name)
      @name = name.to_s
      @exclusive = false

      return unless @name.start_with?('~')

      @name = @name[1..-1]
      @exclusive = true
    end

    # Whether this tag needs to be excluded or not.
    #
    # return [boolean]
    def exclusive?
      @exclusive
    end

    # Whether this tag needs to be included or not.
    #
    # return [boolean]
    def inclusive?
      !exclusive?
    end
  end
end
