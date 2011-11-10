module Flip
  class Forbidden < StandardError
    def initialize(key)
      super("requires :#{key} feature")
    end
  end
end
