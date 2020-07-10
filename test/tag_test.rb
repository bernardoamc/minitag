# frozen_string_literal: true

require 'test_helper'

module Minitag
  class TagTest < Minitest::Test
    def test_tag_inclusive
      tag = Tag.new('foo')
      assert_predicate tag, :inclusive?
      assert_equal 'foo', tag.name
    end

    def test_tag_exclusive
      tag = Tag.new('~foo')
      assert_predicate tag, :exclusive?
      assert_equal 'foo', tag.name
    end
  end
end
