# frozen_string_literal: true

module Minitag
  # Module used to extend classes that rely on tags.
  # It has the following responsibilities:
  #   - Associate tags with tests
  #   - Filter tests based on the specified tags
  module TagExtension
    define_method(:method_added) do |name|
      if name[/\Atest_/]
        Minitag.context.add_tags(
          namespace: self, name: name, tags: Minitag.pending_tags
        )

        Minitag.pending_tags = []
      end
    end

    def runnable_methods
      methods = super.dup
      return methods if Minitag.context.no_filters?

      methods.select do |runnable_method|
        Minitag.context.match?(namespace: self, name: runnable_method)
      end
    end
  end
end
