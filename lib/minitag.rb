# frozen_string_literal: true

require 'set'
require 'minitest'
require 'minitag/version'
require 'minitag/context'
require 'minitag/extension_registry'
require 'minitag/minitest_tag'
require 'minitag/tag_extension'

# Namespace for classes or modules providing tagging functionality
# to Minitest::Test
module Minitag
  class << self
    # Registry of classes that requires extension by Minitag::TagExtension.
    def extension_registry
      @extension_registry ||= ExtensionRegistry.new
    end

    # Register a class for extension.
    def register_for_extension(klass)
      extension_registry.register(klass)
    end

    # Execution context of the test suite.
    def context
      @context ||= Context.new
    end

    # Add filtering tag to context specified by the `--tag` or `-t` option.
    def add_filter(tag)
      context.add_filter(tag)
    end

    # Tags from the last `tag` method awaiting to be associated with a test.
    def pending_tags
      @pending_tags || []
    end

    # Tags set from the `tag` method.
    def pending_tags=(tags)
      @pending_tags = Array(tags)
    end
  end
end
