# frozen_string_literal: true

module Minitag
  # Module used to extend Minitest::Test.
  # It has the following responsibilities:
  #   - Introduce the tag functionality
  #   - Associate tags with tests
  #   - Filter tests based on the specified tags
  module TagExtension
    def tag(*tags)
      Minitag.pending_tags = tags
    end

    define_method(:method_added) do |name|
      if name[/\Atest_/]
        Minitag.pending_tags.each do |pending_tag|
          Minitag.tag_mapping.add(context: self, name: name, tag: pending_tag)
        end

        Minitag.pending_tags = []
      end
    end

    def runnable_methods
      methods = super.dup
      return methods if Minitag.execution_tags.empty? || methods.empty?

      execution_tags = Minitag.execution_tags
      inclusive_tags = execution_tags.select(&:inclusive?).map(&:name)
      exclusive_tags = execution_tags.select(&:exclusive?).map(&:name)

      methods.select do |runnable_method|
        runnable_method_tags = Minitag.tag_mapping.fetch(context: self, name: runnable_method).map(&:name)

        Minitag::TagMatcher.inclusive_match?(inclusive_tags, runnable_method_tags) &&
          Minitag::TagMatcher.exclusive_match?(exclusive_tags, runnable_method_tags)
      end
    end
  end
end

Minitest::Test.singleton_class.prepend(Minitag::TagExtension)
