# frozen_string_literal: true

require 'test_helper'

module Minitag
  class MinitagScenariosTest < Minitest::Test
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

  class MinitagTest < Minitest::Test
    def test_no_tags
      with_context do
        expected = %w[test_1 test_2 test_3 test_4]
        assert_equal expected, MinitagScenariosTest.runnable_methods.sort
      end
    end

    def test_inclusive_test
      with_context(filters: %w[foo]) do
        expected = %w[test_1 test_3]
        assert_equal expected, MinitagScenariosTest.runnable_methods.sort
      end
    end

    def test_multiple_inclusive_test
      with_context(filters: %w[foo bar]) do
        expected = %w[test_1 test_2 test_3]
        assert_equal expected, MinitagScenariosTest.runnable_methods.sort
      end
    end

    def test_exclusive_test
      with_context(filters: %w[~foo]) do
        expected = %w[test_2 test_4]
        assert_equal expected, MinitagScenariosTest.runnable_methods.sort
      end
    end

    def test_multiple_exclusive_test
      with_context(filters: %w[~foo ~bar]) do
        expected = ['test_4']
        assert_equal expected, MinitagScenariosTest.runnable_methods.sort
      end
    end

    def test_inclusion_and_exclusion
      with_context(filters: %w[foo ~bar]) do
        expected = ['test_1']
        assert_equal expected, MinitagScenariosTest.runnable_methods.sort
      end
    end

    private

    def with_context(filters: [])
      filters.each { |filter| Minitag.context.add_filter(filter) }
      yield
      Minitag.context.instance_variable_set(:@inclusive_filters, Set.new)
      Minitag.context.instance_variable_set(:@exclusive_filters, Set.new)
    end
  end
end
