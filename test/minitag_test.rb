# frozen_string_literal: true

require 'test_helper'

module Minitag
  class MinitagScenariosTest < Minitest::Test
    tag_namespace 'all'

    tag 'foo'
    def test_1
      skip 'Test scenario'
    end

    tag 'bar'
    def test_2
      skip 'Test scenario'
    end

    tag 'foo', 'bar'
    def test_3
      skip 'Test scenario'
    end

    def test_4
      skip 'Test scenario'
    end
  end

  class MinitagWithoutTagsTest < Minitest::Test
  end

  class MinitagNamespaceTagsTest < Minitest::Test
    tag_namespace 'all'
  end

  class MinitagTest < Minitest::Test
    ########################
    # TEST ANCESTORS CHAIN #
    ########################
    def test_class_without_tags_dont_have_tag_extension_as_ancestor
      refute_includes MinitagWithoutTagsTest.singleton_class.ancestors, TagExtension
    end

    def test_class_with_namespace_tags_dont_have_tag_extension_as_ancestor
      refute_includes MinitagNamespaceTagsTest.singleton_class.ancestors, TagExtension
    end

    def test_class_with_test_tags_have_tag_extension_as_ancestor
      assert_includes MinitagScenariosTest.singleton_class.ancestors, TagExtension
    end

    def test_every_class_should_have_minitest_tag_as_ancestor
      assert_includes MinitagWithoutTagsTest.singleton_class.ancestors, MinitestTag
      assert_includes MinitagNamespaceTagsTest.singleton_class.ancestors, MinitestTag
      assert_includes MinitagScenariosTest.singleton_class.ancestors, MinitestTag
    end

    ######################
    # TEST TAGGING LOGIC #
    ######################
    def test_no_filter_tags
      with_context do
        expected = %w[test_1 test_2 test_3 test_4]
        assert_equal expected, MinitagScenariosTest.runnable_methods.sort
      end
    end

    def test_inclusive_match_test_tags
      with_context(filters: %w[foo]) do
        expected = %w[test_1 test_3]
        assert_equal expected, MinitagScenariosTest.runnable_methods.sort
      end
    end

    def test_multiple_inclusive_match_test_tags
      with_context(filters: %w[foo bar]) do
        expected = %w[test_1 test_2 test_3]
        assert_equal expected, MinitagScenariosTest.runnable_methods.sort
      end
    end

    def test_inclusive_match_namespace_tags
      with_context(filters: %w[all]) do
        expected = %w[test_1 test_2 test_3 test_4]
        assert_equal expected, MinitagScenariosTest.runnable_methods.sort
      end
    end

    def test_exclusive_match_test_tags
      with_context(filters: %w[~foo]) do
        expected = %w[test_2 test_4]
        assert_equal expected, MinitagScenariosTest.runnable_methods.sort
      end
    end

    def test_exclusive_match_namespace_tags
      with_context(filters: %w[~all]) do
        expected = []
        assert_equal expected, MinitagScenariosTest.runnable_methods.sort
      end
    end

    def test_multiple_exclusive_match_test_tags
      with_context(filters: %w[~foo ~bar]) do
        expected = %w[test_4]
        assert_equal expected, MinitagScenariosTest.runnable_methods.sort
      end
    end

    def test_inclusion_and_exclusion_match_test_tags
      with_context(filters: %w[foo ~bar]) do
        expected = %w[test_1]
        assert_equal expected, MinitagScenariosTest.runnable_methods.sort
      end
    end

    def test_inclusion_and_exclusion_match_namespace_and_test_tags
      with_context(filters: %w[all ~bar]) do
        expected = %w[test_1 test_4]
        assert_equal expected, MinitagScenariosTest.runnable_methods.sort
      end
    end
  end
end
