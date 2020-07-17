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

      Minitag.register_for_extension(self)
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
  end
end

Minitest::Test.singleton_class.prepend(Minitag::MinitestTag)
