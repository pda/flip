# Database backed system-wide
module Flip
  class DatabaseStrategy < AbstractStrategy

    def initialize(model_klass = Feature)
      @klass = model_klass
    end

    def description
      "Database backed, applies to all users."
    end

    def status definition
      feature = feature(definition)
      feature.enabled? if feature
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
        @klass.feature_cache[definition.key.to_s]
      else
        @klass.where(key: definition.key.to_s).first
      end
    end

  end
end
