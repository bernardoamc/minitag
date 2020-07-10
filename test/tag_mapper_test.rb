require "test_helper"

module Minitag
  class TagMapperTest < Minitest::Test
    def test_add_and_fetch
      mapper = TagMapper.new
      mapper.add(context: 'test', name: 'add', tag: 'cool')
      tags = mapper.fetch(context: 'test', name: 'add')
      assert_equal ['cool'], tags.map(&:name)

      mapper.add(context: 'test', name: 'add', tag: 'yay')
      tags = mapper.fetch(context: 'test', name: 'add')
      assert_equal ['cool', 'yay'], tags.map(&:name)
    end
  end
end
