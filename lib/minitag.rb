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
    def execution_tags
      @execution_tags ||= []
    end

    def add_execution_tag(tag)
      execution_tags << Tag.new(tag)
    end

    def pending_tags
      @pending_tags || []
    end

    def pending_tags=(tags)
      @pending_tags = Array(tags)
    end

    def tag_mapping
      @tag_mapping ||= Minitag::TagMapper.new
    end
  end
end
