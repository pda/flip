module Flip
  class FeatureSet

    def self.instance
      @instance ||= self.new
    end

    def self.reset
      @instance = nil
    end

    # Sets the default for definitions which fall through the strategies.
    # Accepts boolean or a Proc to be called.
    attr_writer :default

    def initialize
      @definitions = Hash.new { |_, k| raise "No feature declared with key #{k.inspect}" }
      @strategies = Hash.new { |_, k| raise "No strategy named #{k}. Valid strategies are #{@strategies.keys}" }
      @default = false
    end

    # Whether the given feature is switched on.
    def on? key
      d = @definitions[key]
      strategies = @strategies.each_value.lazy
      status = strategies.map { |s| s.status(d) }.detect { |s| !s.nil? }
      return default_for d if status.nil? # not known by any strategies
      status
    end

    # Adds a feature definition to the set.
    def << definition
      @definitions[definition.key] = definition
    end

    # Adds a strategy for determing feature status.
    def add_strategy(strategy)
      strategy = strategy.new if strategy.is_a? Class
      @strategies[strategy.name] = strategy
    end

    def strategy(klass)
      @strategies[klass]
    end

    def default_for(definition)
      @default.is_a?(Proc) ? @default.call(definition) : @default
    end

    def definitions
      @definitions.values
    end

    def strategies
      @strategies.values
    end

  end
end
