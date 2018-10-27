module Flip
  class MemoryCache < AbstractStrategy
    def initialize(strategy, ttl: 60)
      @strategy = strategy
      @ttl = ttl
      @cache = {}
    end

    def description
      @strategy.description
    end

    def switchable?
      @strategy.switchable?
    end

    def status(definition, now: Process.clock_gettime(Process::CLOCK_MONOTONIC))
      fetch(definition.key, now) { @strategy.status(definition) }
    end

    def switch!(key, enable)
      raise unless switchable?
      @strategy.switch!(definition, enable)
      @cache.delete(key)
    end

    def delete!(key)
      raise unless switchable?
      @strategy.delete!(key)
      @cache.delete(key)
    end

    private

    def fetch(key, now)
      value, expiration = @cache.fetch(key, [nil, 0])
      cache_miss = now > expiration

      if cache_miss
        value = yield
        @cache[key] = [value, now + @ttl]
      end

      value
    end
  end
end
