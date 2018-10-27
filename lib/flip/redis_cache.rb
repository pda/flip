module Flip
  class RedisCache < AbstractStrategy
    def initialize(strategy, ttl: 60, key_prefix: 'flip:cache:', redis: ::Redis.current)
      super(key_prefix: key_prefix)
      @strategy = strategy
      @ttl = ttl.to_i.clamp(1, 2**63 - 1) # safe for redis
      @redis = redis
    end

    def description
      "#{@strategy.description} Cached with Redis."
    end

    def switchable?
      @strategy.switchable?
    end

    def status(definition)
      fetch(definition.key) { @strategy.status(definition) }
    end

    def switch!(key, enable)
      raise unless switchable?
      @strategy.switch!(definition, enable)
      @redis.del(cache_key(key))
    end

    def delete!(key)
      raise unless switchable?
      @strategy.delete!(key)
      @redis.del(cache_key(key))
    end

    private

    def fetch(key)
      serialized = @redis.get(cache_key(key))
      cache_miss = serialized.nil?

      if cache_miss
        value = yield
        @redis.setex(cache_key(key), @ttl, value.to_yaml)
        value
      else
        YAML.load(serialized)
      end
    end
  end
end
