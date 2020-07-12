# frozen_string_literal: true

module Minitag
  # Module used to extend Minitest::Test.
  # It has the following responsibilities:
  #   - Introduce the tag functionality
  #   - Associate tags with tests
  #   - Filter tests based on the specified tags
  module TagExtension
    # Add tags to be associated with the next test definition.
    #
    # It is important to notice that tags associated with a test have no concept
    # of inclusive or exclusive tags. This distinction is only valid for tag
    # filters.
    #
    # @param [Array] tags the list of tags to be associated with a test case.
    #
    # return [void]
    def tag(*tags)
      Minitag.pending_tags = tags.map { |tag| tag.to_s.strip.downcase }
    end

    define_method(:method_added) do |name|
      if name[/\Atest_/]
        Minitag.context.add_tags(
          namespace: self, name: name, tags: Minitag.pending_tags
        )

        Minitag.pending_tags = []
      end
    end

    def runnable_methods
      methods = super.dup
      return methods if Minitag.context.no_filters?

      methods.select do |runnable_method|
        Minitag.context.match?(namespace: self, name: runnable_method)
      end
    end
  end
end

Minitest::Test.singleton_class.prepend(Minitag::TagExtension)
