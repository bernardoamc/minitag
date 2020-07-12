# frozen_string_literal: true

require 'test_helper'

module Minitag
  class TagRegistryTest < Minitest::Test
    def test_add_and_fetch
      tag_registry = TagRegistry.new
      tag_registry.add(namespace: 'test', name: 'add', tags: %w[cool yay])
      tags = tag_registry.fetch(namespace: 'test', name: 'add')
      assert_equal Set.new(%w[cool yay]), tags
    end

    def test_add_and_fetch_with_duplicated_tags
      tag_registry = TagRegistry.new
      tag_registry.add(namespace: 'test', name: 'add', tags: %w[cool cool yay])
      tags = tag_registry.fetch(namespace: 'test', name: 'add')
      assert_equal Set.new(%w[cool yay]), tags
    end
  end
end
