module Flip
  module Cacheable

    def use_feature_cache
      @use_feature_cache
    end

    def clear_feature_cache
      @use_feature_cache = true
      @features = nil
    end

    def feature_cache
      @features ||= all
    end

  end
end
