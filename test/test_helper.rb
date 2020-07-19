# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'minitag'

require 'minitest/autorun'

def with_context(filters: [])
  filters.each { |filter| Minitag.context.add_filter(filter) }
  yield
  Minitag.context.instance_variable_set(:@inclusive_filters, Set.new)
  Minitag.context.instance_variable_set(:@exclusive_filters, Set.new)
end
