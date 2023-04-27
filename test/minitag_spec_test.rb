# frozen_string_literal: true

require 'test_helper'

describe Minitag do
  scenarios_class = describe 'Scenarios' do
    tag_namespace 'all'

    tag 'foo'
    it 'spec_1' do
      assert true
    end

    tag 'bar'
    it 'spec_2' do
      assert true
    end

    tag 'foo', 'bar'
    it 'spec_3' do
      assert true
    end

    it 'spec_4' do
      assert true
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

    it 'runs without filtering tags even with skipping enabled' do
      with_context(skip_filtered: true) do
        expected = %w[test_0001_spec_1 test_0002_spec_2 test_0003_spec_3 test_0004_spec_4]
        _(scenarios_class.runnable_methods.sort).must_equal expected
      end
    end

    it 'does not skip with skipping enabled without filtering tags' do
      with_context(skip_filtered: true) do
        reporter = Minitest::StatisticsReporter.new
        scenarios_class.run_one_method(scenarios_class, 'test_0001_spec_1', reporter)
        _(reporter.count).must_equal 1
        _(reporter.results).must_be_empty
      end
    end

    it 'test_inclusive_match_test_tags' do
      with_context(filters: %w[foo]) do
        expected = %w[test_0001_spec_1 test_0003_spec_3]
        _(scenarios_class.runnable_methods.sort).must_equal expected
      end
    end

    it 'test_inclusive_match_test_tags_skip_runnable' do
      with_context(filters: %w[foo], skip_filtered: true) do
        # runnable_methods shouldn't filter at all
        expected = %w[test_0001_spec_1 test_0002_spec_2 test_0003_spec_3 test_0004_spec_4]
        _(scenarios_class.runnable_methods.sort).must_equal expected
      end
    end

    it 'test_skip_with_inclusive_match_test_tags' do
      with_context(filters: %w[foo], skip_filtered: true) do
        reporter = Minitest::StatisticsReporter.new
        scenarios_class.run_one_method(scenarios_class, 'test_0002_spec_2', reporter)
        _(reporter.count).must_equal 1
        _(reporter.results.length).must_equal 1
        result = reporter.results.first
        _(result.name).must_equal 'test_0002_spec_2'
        assert result.skipped?
        assert reporter.passed?
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

    it 'test_exclusive_match_test_tags_skip_runnable' do
      with_context(filters: %w[~foo], skip_filtered: true) do
        # runnable_methods shouldn't filter at all
        expected = %w[test_0001_spec_1 test_0002_spec_2 test_0003_spec_3 test_0004_spec_4]
        _(scenarios_class.runnable_methods.sort).must_equal expected
      end
    end

    it 'test_skip_exclusive_match_test_tags' do
      with_context(filters: %w[~foo], skip_filtered: true) do
        reporter = Minitest::StatisticsReporter.new
        scenarios_class.run_one_method(scenarios_class, 'test_0001_spec_1', reporter)
        _(reporter.count).must_equal 1
        _(reporter.results.length).must_equal 1
        result = reporter.results.first
        _(result.name).must_equal 'test_0001_spec_1'
        assert result.skipped?
        assert reporter.passed?
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
