# Database backed system-wide
module Flip
  class DatabaseStrategy < AbstractStrategy

    def initialize(model_klass = Feature)
      @klass = model_klass
    end

    def description
      "Database backed, applies to all users."
    end

    def knows? definition
      !!feature(definition)
    end

    def on? definition
      feature(definition).enabled?
    end

    def switchable?
      true
    end

    def switch! key, enable
      @klass.attr_accessible :enabled
      @klass.find_or_initialize_by_key(key).update_attributes! enabled: enable
    end

    def delete! key
      @klass.find_by_key(key).try(:destroy)
    end

    private

    def feature(definition)
      @klass.find_by_key definition.key
    end

  end
end
