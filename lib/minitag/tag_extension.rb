# frozen_string_literal: true

module Minitag
  # Responsible for listening to added methods and associating tags
  # with those.
  module TagExtension
    define_method(:method_added) do |name|
      if name[/\Atest_/]
        Minitag.context.add_test_tags(
          namespace: to_s, name: name, tags: Minitag.pending_tags
        )

        Minitag.pending_tags = []
      end
    end
  end
end
