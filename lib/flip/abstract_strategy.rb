module Flip
  class AbstractStrategy
    def initialize(*args, description: self.class.description, **opts)
      @description = description
    end

    def name
      self.class.name.split("::").last.gsub(/Strategy$/, "").underscore
    end

    attr_reader :description
    # def description; @description || self.class.description; end

    # Returns true for on, false for off and nil for an unknown state
    def status definition; raise; end

    # Whether the feature can be switched on and off at runtime.
    # If true, the strategy must also respond to switch! and delete!
    def switchable?
      false
    end

    def switch! key, on; raise; end
    def delete! key; raise; end

    class << self
      def description(text = nil)
        text.nil? ? @description : @description = text.freeze
      end
    end
  end
end
