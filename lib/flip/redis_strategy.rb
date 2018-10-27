require 'yaml'

module Flip
  class RedisStrategy < AbstractStrategy
    def initialize(key_prefix: 'flip:', redis: ::Redis.current)
      @key_prefix = key_prefix
      @redis = redis
    end

    def description
      "Redis backed, applies to all users."
    end

    def switchable?
      true
    end

    def status(definition)
      serialized = @redis.get(cache_key(key))
      YAML.load(serialized)
    end

    def switch!(key, enable)
      @redis.set(cache_key(key), (!!enable).to_yaml)
    end

    def delete!(key)
      @redis.del(cache_key(key))
    end

    private

    def cache_key(key)
      "#{@key_prefix}#{key}"
    end
  end
end
