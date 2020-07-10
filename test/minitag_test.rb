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
      Minitag.stub(:execution_tags, []) do
        expected = %w[test_1 test_2 test_3 test_4]
        assert_equal expected, MinitagScenariosTest.runnable_methods.sort
      end
    end

    def test_inclusive_test
      Minitag.stub(:execution_tags, [Tag.new('foo')]) do
        expected = %w[test_1 test_3]
        assert_equal expected, MinitagScenariosTest.runnable_methods.sort
      end
    end

    def test_multiple_inclusive_test
      Minitag.stub(:execution_tags, [Tag.new('foo'), Tag.new('bar')]) do
        expected = %w[test_1 test_2 test_3]
        assert_equal expected, MinitagScenariosTest.runnable_methods.sort
      end
    end

    def test_exclusive_test
      Minitag.stub(:execution_tags, [Tag.new('~foo')]) do
        expected = %w[test_2 test_4]
        assert_equal expected, MinitagScenariosTest.runnable_methods.sort
      end
    end

    def test_multiple_exclusive_test
      Minitag.stub(:execution_tags, [Tag.new('~foo'), Tag.new('~bar')]) do
        expected = ['test_4']
        assert_equal expected, MinitagScenariosTest.runnable_methods.sort
      end
    end

    def test_inclusion_and_exclusion
      Minitag.stub(:execution_tags, [Tag.new('foo'), Tag.new('~bar')]) do
        expected = ['test_1']
        assert_equal expected, MinitagScenariosTest.runnable_methods.sort
      end
    end
  end
end
