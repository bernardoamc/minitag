# frozen_string_literal: true

module Minitag
  # Module used to extend Minitest::Test with the tag method.
  module MinitestTag
    # Add tags to be associated with an entire class that inherits from
    # Minitest::Test. Every test that belongs to this class will also inherit
    # these tags.
    #
    # It is important to notice that tags associated with a class have no
    # concept of being inclusive or exclusive. This distinction is only
    # valid for tag filters.
    #
    # @param [Array] tags the list of tags to be associated with a test class.
    #
    # @return [void]
    def tag_namespace(*tags)
      Minitag.context.add_namespace_tags(
        namespace: to_s,
        tags: tags.map { |tag| tag.to_s.strip.downcase }
      )
    end

    # Add tags to be associated with the next test definition and extends the
    # class from which the tag method is being used with Minitag::TagExtension.
    #
    # It is important to notice that tags associated with a test have no concept
    # of being inclusive or exclusive. This distinction is only valid for tag
    # filters.
    #
    # @param [Array] tags the list of tags to be associated with a test case.
    #
    # @return [void]
    def tag(*tags)
      Minitag.pending_tags = tags.map { |tag| tag.to_s.strip.downcase }
      Minitag.register_for_extension(self)
    end

    def run_one_method(klass, method_name, reporter) # rubocop:disable Metrics/AbcSize
      return super if !Minitag.skip_filtered? || Minitag.context.no_filters? ||
                      Minitag.context.match?(namespace: to_s, name: method_name)

      # Skip this test
      test = klass.new(method_name)
      test.time = 0
      skip = Minitest::Skip.new('This test did not match filters')
      source = test.method(method_name).source_location
      skip.set_backtrace(["#{source[0]}:#{source[1]}"])
      test.failures << skip
      reporter.prerecord(self, method_name)
      reporter.record(Minitest::Result.from(test))
    end

    # Decides which methods to run based on an Array of test names provided by
    # the superclass and the tags defined within test classes.
    #
    # Invariants:
    #   - Returns the full list of test names when the test suite runs without
    #   any tag filtering.
    #
    # @return [Array] the list of test names that should run.
    def runnable_methods
      methods = super.dup
      return methods if Minitag.skip_filtered? || Minitag.context.no_filters?

      methods.select do |runnable_method|
        Minitag.context.match?(namespace: to_s, name: runnable_method)
      end
    end
  end
end

Minitest::Test.singleton_class.prepend(Minitag::MinitestTag)
