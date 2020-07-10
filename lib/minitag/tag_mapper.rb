module Minitag
  class TagMapper
    attr_reader :repository

    def initialize
      @repository = Hash.new { |h, k| h[k] = [] }
    end

    def add(context:, name:, tag:)
      @repository[key(context, name)] << Minitag::Tag.new(tag)
    end

    def fetch(context:, name:)
      @repository[key(context, name)]
    end

    private

    def key(context, name)
      "#{context}_#{name}"
    end
  end
end
