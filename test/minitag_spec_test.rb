# frozen_string_literal: true

require 'test_helper'

describe Minitag do
  scenarios_class = describe 'Scenarios' do
    tag_namespace 'all'

    tag 'foo'
    it 'spec_1' do
      skip 'Test scenario'
    end

    tag 'bar'
    it 'spec_2' do
      skip 'Test scenario'
    end

    tag 'foo', 'bar'
    it 'spec_3' do
      skip 'Test scenario'
    end

    it 'spec_4' do
      skip 'Test scenario'
    end
  end

  without_tags_class = describe 'Without Tags' do
  end

  namespace_tags_class = describe 'Namespace Tags' do
    tag_namespace 'all'
  end

  describe 'Ancestors' do
    it 'test_class_without_tags_dont_have_tag_extension_as_ancestor' do
      refute_includes without_tags_class.singleton_class.ancestors, Minitag::TagExtension
    end

    it 'test_class_with_namespace_tags_dont_have_tag_extension_as_ancestor' do
      refute_includes namespace_tags_class.singleton_class.ancestors, Minitag::TagExtension
    end

    it 'test_class_with_test_tags_have_tag_extension_as_ancestor' do
      assert_includes scenarios_class.singleton_class.ancestors, Minitag::TagExtension
    end

    it 'test_every_class_should_have_minitest_tag_as_ancestor' do
      assert_includes without_tags_class.singleton_class.ancestors, Minitag::MinitestTag
      assert_includes namespace_tags_class.singleton_class.ancestors, Minitag::MinitestTag
      assert_includes scenarios_class.singleton_class.ancestors, Minitag::MinitestTag
    end
  end

  describe 'Tagging' do
    it 'runs without filtering tags' do
      with_context do
        expected = %w[test_0001_spec_1 test_0002_spec_2 test_0003_spec_3 test_0004_spec_4]
        _(scenarios_class.runnable_methods.sort).must_equal expected
      end
    end

    it 'test_inclusive_match_test_tags' do
      with_context(filters: %w[foo]) do
        expected = %w[test_0001_spec_1 test_0003_spec_3]
        _(scenarios_class.runnable_methods.sort).must_equal expected
      end
    end

    it 'test_multiple_inclusive_match_test_tags' do
      with_context(filters: %w[foo bar]) do
        expected = %w[test_0001_spec_1 test_0002_spec_2 test_0003_spec_3]
        _(scenarios_class.runnable_methods.sort).must_equal expected
      end
    end

    it 'test_inclusive_match_namespace_tags' do
      with_context(filters: %w[all]) do
        expected = %w[test_0001_spec_1 test_0002_spec_2 test_0003_spec_3 test_0004_spec_4]
        _(scenarios_class.runnable_methods.sort).must_equal expected
      end
    end

    it 'test_exclusive_match_test_tags' do
      with_context(filters: %w[~foo]) do
        expected = %w[test_0002_spec_2 test_0004_spec_4]
        _(scenarios_class.runnable_methods.sort).must_equal expected
      end
    end

    it 'test_exclusive_match_namespace_tags' do
      with_context(filters: %w[~all]) do
        expected = []
        _(scenarios_class.runnable_methods.sort).must_equal expected
      end
    end

    it 'test_multiple_exclusive_match_test_tags' do
      with_context(filters: %w[~foo ~bar]) do
        expected = %w[test_0004_spec_4]
        _(scenarios_class.runnable_methods.sort).must_equal expected
      end
    end

    it 'test_inclusion_and_exclusion_match_test_tags' do
      with_context(filters: %w[foo ~bar]) do
        expected = %w[test_0001_spec_1]
        _(scenarios_class.runnable_methods.sort).must_equal expected
      end
    end

    it 'test_inclusion_and_exclusion_match_namespace_and_test_tags' do
      with_context(filters: %w[all ~bar]) do
        expected = %w[test_0001_spec_1 test_0004_spec_4]
        _(scenarios_class.runnable_methods.sort).must_equal expected
      end
    end
  end
end
