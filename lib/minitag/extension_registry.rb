# frozen_string_literal: true

module Minitag
  # Stores and extends classes that relies on tags with the Minitag::TagExtension
  # module.
  class ExtensionRegistry
    def initialize
      @registry = {}
    end

    # Extends a class with Minitag::TagExtension and stores it as extended.
    #
    # Invariants:
    #   - Classes that were already extended will be ignored during this operation.
    #
    # @param [Class] klass a class that will be extended.
    #
    # @return [void]
    def register(klass)
      return if @registry.key?(klass)

      @registry[klass] = true
      klass.singleton_class.prepend(Minitag::TagExtension)
    end
  end
end
