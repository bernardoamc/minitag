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

    ###################
    # INCLUSIVE TESTS #
    ###################
    def test_match_when_inclusive_filter_exists_and_namespace_and_test_tags_are_empty
      @context.add_filter('foo')

      result = @context.match?(namespace: 'nonexistent', name: 'nonexistent')
      assert_equal false, result
    end

    def test_match_when_inclusive_filter_does_not_match_test_tags
      @context.add_test_tags(namespace: 'ctx', name: 'test', tags: %w[bar])
      @context.add_filter('foo')

      result = @context.match?(namespace: 'ctx', name: 'test')
      assert_equal false, result
    end

    def test_match_when_inclusive_filter_does_not_match_namespace_tags
      @context.add_namespace_tags(namespace: 'ctx', tags: %w[bar])
      @context.add_filter('foo')

      result = @context.match?(namespace: 'ctx', name: 'test')
      assert_equal false, result
    end

    def test_match_when_inclusive_filters_are_empty
      @context.add_test_tags(namespace: 'ctx', name: 'test', tags: %w[foo])
      @context.add_namespace_tags(namespace: 'ctx', tags: %w[bar])

      result = @context.match?(namespace: 'ctx', name: 'test')
      assert_equal true, result
    end

    def test_match_when_inclusive_filter_match_test_tags
      @context.add_test_tags(namespace: 'ctx', name: 'test', tags: %w[foo])
      @context.add_filter('foo')

      result = @context.match?(namespace: 'ctx', name: 'test')
      assert_equal true, result
    end

    def test_match_when_inclusive_filter_match_namespace_tags
      @context.add_namespace_tags(namespace: 'ctx', tags: %w[foo])
      @context.add_filter('foo')

      result = @context.match?(namespace: 'ctx', name: 'test')
      assert_equal true, result
    end

    def test_match_when_inclusive_filters_matches_at_least_one_test_tag
      @context.add_test_tags(namespace: 'ctx', name: 'test', tags: %w[bar yay foo])
      @context.add_filter('foo')

      result = @context.match?(namespace: 'ctx', name: 'test')
      assert_equal true, result
    end

    def test_match_when_inclusive_filter_matches_at_least_one_namespace_tag
      @context.add_namespace_tags(namespace: 'ctx', tags: %w[bar yay foo])
      @context.add_filter('foo')

      result = @context.match?(namespace: 'ctx', name: 'test')
      assert_equal true, result
    end

    ###################
    # EXCLUSIVE TESTS #
    ###################
    def test_match_when_exclusive_filter_matches_test_tag
      @context.add_test_tags(namespace: 'ctx', name: 'test', tags: %w[foo])
      @context.add_filter('~foo')

      result = @context.match?(namespace: 'ctx', name: 'test')
      assert_equal false, result
    end

    def test_match_when_exclusive_filter_matches_namespace_tag
      @context.add_namespace_tags(namespace: 'ctx', tags: %w[foo])
      @context.add_filter('~foo')

      result = @context.match?(namespace: 'ctx', name: 'test')
      assert_equal false, result
    end

    def test_match_when_exclusive_filter_matches_at_least_one_test_tag
      @context.add_test_tags(namespace: 'ctx', name: 'test', tags: %w[bar yay foo])
      @context.add_filter('~foo')

      result = @context.match?(namespace: 'ctx', name: 'test')
      assert_equal false, result
    end

    def test_match_when_exclusive_filter_matches_at_least_one_namespace_tag
      @context.add_namespace_tags(namespace: 'ctx', tags: %w[bar yay foo])
      @context.add_filter('~foo')

      result = @context.match?(namespace: 'ctx', name: 'test')
      assert_equal false, result
    end

    def test_match_when_exclusive_filters_does_not_match_test_tags
      @context.add_test_tags(namespace: 'ctx', name: 'test', tags: %w[foo])
      @context.add_filter('~bar')

      result = @context.match?(namespace: 'ctx', name: 'test')
      assert_equal true, result
    end

    def test_match_when_exclusive_filters_does_not_match_namespace_tags
      @context.add_namespace_tags(namespace: 'ctx', tags: %w[foo])
      @context.add_filter('~bar')

      result = @context.match?(namespace: 'ctx', name: 'test')
      assert_equal true, result
    end

    def test_match_when_exclusive_filters_are_empty
      @context.add_test_tags(namespace: 'ctx', name: 'test', tags: %w[foo])
      @context.add_namespace_tags(namespace: 'ctx', tags: %w[bar])

      result = @context.match?(namespace: 'ctx', name: 'test')
      assert_equal true, result
    end

    def test_match_when_exclusive_filters_exists_and_test_and_namespace_tags_are_empty
      @context.add_filter('~foo')

      result = @context.match?(namespace: 'ctx', name: 'test')
      assert_equal true, result
    end
  end
end
