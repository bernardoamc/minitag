# frozen_string_literal: true

module Minitag
  # Represents a tag in our system.
  # Provides helper methods to identify the type of a tag, which can
  # only one of the following:
  #   - inclusive
  #   - exclusive (name with ~ as a prefix)
  class Tag
    attr_reader :name

    def initialize(name)
      @name = name.to_s
      @exclusive = false

      return unless @name.start_with?('~')

      @name = @name[1..-1]
      @exclusive = true
    end

    def exclusive?
      @exclusive
    end

    def inclusive?
      !exclusive?
    end
  end
end
