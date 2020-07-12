# frozen_string_literal: true

require 'test_helper'

module Minitag
  class ContextTest < Minitest::Test
    def setup
      @context = Context.new
    end

    def no_filters_returns_true_when_there_are_no_filters
      assert_equal true, @context.no_filters?
    end

    def no_filters_returns_false_when_there_are_filters
      @context.add_filter('my_tag')

      assert_equal false, @context.no_filters?
    end

    def test_match_when_inclusive_filter_exists_and_test_tags_are_empty
      @context.add_filter('foo')

      result = @context.match?(namespace: 'nonexistent', name: 'nonexistent')
      assert_equal false, result
    end

    def test_match_when_inclusive_filter_does_not_match_test_tags
      @context.add_tags(namespace: 'ctx', name: 'test', tags: %w[bar])
      @context.add_filter('foo')

      result = @context.match?(namespace: 'ctx', name: 'test')
      assert_equal false, result
    end

    def test_match_when_inclusive_filters_are_empty
      @context.add_tags(namespace: 'ctx', name: 'test', tags: %w[bar])

      result = @context.match?(namespace: 'ctx', name: 'test')
      assert_equal true, result
    end

    def test_match_when_inclusive_filter_match_test_tags
      @context.add_tags(namespace: 'ctx', name: 'test', tags: %w[foo])
      @context.add_filter('foo')

      result = @context.match?(namespace: 'ctx', name: 'test')
      assert_equal true, result
    end

    def test_match_when_inclusive_filters_matches_at_least_one_existing_tag
      @context.add_tags(namespace: 'ctx', name: 'test', tags: %w[bar yay foo])
      @context.add_filter('foo')

      result = @context.match?(namespace: 'ctx', name: 'test')
      assert_equal true, result
    end

    def test_match_when_exclusive_filter_matches_existing_tag
      @context.add_tags(namespace: 'ctx', name: 'test', tags: %w[foo])
      @context.add_filter('~foo')

      result = @context.match?(namespace: 'ctx', name: 'test')
      assert_equal false, result
    end

    def test_match_when_exclusive_filter_matches_at_least_one_existing_tag
      @context.add_tags(namespace: 'ctx', name: 'test', tags: %w[bar yay foo])
      @context.add_filter('~foo')

      result = @context.match?(namespace: 'ctx', name: 'test')
      assert_equal false, result
    end

    def test_match_when_exclusive_filters_does_not_match_existing_tags
      @context.add_tags(namespace: 'ctx', name: 'test', tags: %w[foo])
      @context.add_filter('~bar')

      result = @context.match?(namespace: 'ctx', name: 'test')
      assert_equal true, result
    end

    def test_match_when_exclusive_filters_are_empty
      @context.add_tags(namespace: 'ctx', name: 'test', tags: %w[foo])

      result = @context.match?(namespace: 'ctx', name: 'test')
      assert_equal true, result
    end

    def test_match_when_exclusive_filters_exists_and_existing_tags_are_empty
      @context.add_filter('~foo')

      result = @context.match?(namespace: 'ctx', name: 'test')
      assert_equal true, result
    end
  end
end
