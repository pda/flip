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
      record = @klass.where(key: key.to_s).first_or_initialize
      record.enabled = enable
      record.save!
    end

    def delete! key
      @klass.where(key: key.to_s).first.try(:destroy)
    end

    private

    def feature(definition)
      if @klass.respond_to?(:use_feature_cache) && @klass.use_feature_cache
        @klass.feature_cache.select{ |f| f.key == definition.key.to_s }.first
      else
        @klass.where(key: definition.key.to_s).first
      end
    end

  end
end
