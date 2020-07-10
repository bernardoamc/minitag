require "test_helper"

module Minitag
  class TagMatcherTest < Minitest::Test
    def test_tag_inclusive_match_when_desired_tags_exists_and_existing_tags_are_empty
      result = TagMatcher.inclusive_match?(['foo'], [])
      assert_equal false, result
    end

    def test_tag_inclusive_match_when_desired_tags_does_not_match_existing_tags
      result = TagMatcher.inclusive_match?(['foo'], ['bar'])
      assert_equal false, result
    end

    def test_tag_inclusive_match_when_desired_tags_are_empty
      result = TagMatcher.inclusive_match?([], ['foo'])
      assert_equal true, result
    end

    def test_tag_inclusive_match_when_desired_tag_matches_existing_tag
      result = TagMatcher.inclusive_match?(['foo'], ['foo'])
      assert_equal true, result
    end

    def test_tag_inclusive_match_when_desired_tag_matches_at_least_one_existing_tag
      result = TagMatcher.inclusive_match?(['foo'], ['bar', 'yay', 'foo'])
      assert_equal true, result
    end

    def test_tag_exclusive_match_when_desired_tag_matches_existing_tag
      result = TagMatcher.exclusive_match?(['foo'], ['foo'])
      assert_equal false, result
    end

    def test_tag_exclusive_match_when_desired_tag_matches_at_least_one_existing_tag
      result = TagMatcher.exclusive_match?(['foo'], ['bar', 'yay', 'foo'])
      assert_equal false, result
    end

    def test_tag_exclusive_match_when_desired_tags_does_not_match_existing_tags
      result = TagMatcher.exclusive_match?(['foo'], ['bar'])
      assert_equal true, result
    end

    def test_tag_exclusive_match_when_desired_tags_are_empty
      result = TagMatcher.exclusive_match?([], ['foo'])
      assert_equal true, result
    end

    def test_tag_exclusive_match_when_desired_tags_exists_and_existing_tags_are_empty
      result = TagMatcher.exclusive_match?(['foo'], [])
      assert_equal true, result
    end
  end
end
