# frozen_string_literal: true

require 'minitest'
require 'minitag/version'
require 'minitag/tag'
require 'minitag/tag_mapper'
require 'minitag/tag_matcher'
require 'minitag/tag_extension'

# Namespace for classes or modules providing tagging functionality
# to Minitest::Test
module Minitag
  class << self
    # Tags specified by the `--tag` or `-t` option.
    def execution_tags
      @execution_tags ||= []
    end

    # Add tag specified by the `--tag` or `-t` option.
    def add_execution_tag(tag)
      execution_tags << Tag.new(tag)
    end

    # Tags from the last `tag` method waiting to be associated with a test.
    def pending_tags
      @pending_tags || []
    end

    # Tags set from the `tag` method.
    def pending_tags=(tags)
      @pending_tags = Array(tags)
    end

    # The mapping of tags and tests.
    def tag_mapping
      @tag_mapping ||= Minitag::TagMapper.new
    end
  end
end
