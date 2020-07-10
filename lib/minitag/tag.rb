module Minitag
  class Tag
    attr_reader :name

    def initialize(name)
      @name = name.to_s
      @exclusive = false

      if @name.to_s.start_with?('~')
        @name = @name[1..-1]
        @exclusive = true
      end
    end

    def exclusive?
      @exclusive
    end

    def inclusive?
      !exclusive?
    end
  end
end
