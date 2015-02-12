module Flip
  module Cacheable

    def use_feature_cache=(value)
      @use_feature_cache = value
    end

    def use_feature_cache
      @use_feature_cache
    end

    def start_feature_cache
      @use_feature_cache = true
      @features = nil
    end

    def feature_cache
      return @features if @features
      @features = {}
      all.each { |f| @features[f.key] = f }
      @features
    end

  end
end
