module Flip::Declarable
  extend ActiveSupport::Concern

  included do
    @feature_set ||= Flip::FeatureSet.new
  end

  module ClassMethods

    attr_reader :feature_set

    # Whether the given feature is switched on.
    def on?(key)
      feature_set.on? key
    end

    private

    # Adds a new feature definition, creates predicate method.
    def feature(key, options = {})
      feature_set << Flip::Definition.new(key, options)
      define_feature_predicate_method key
    end

    # Adds a strategy for determining feature status.
    def strategy(strategy)
      feature_set.add_strategy strategy
    end

    # The default response, boolean or a Proc to be called.
    def default(default)
      feature_set.default = default
    end

    # Defines a predicate method like Flip.feature_name?
    def define_feature_predicate_method(key)
      (class << self; self; end).send(:define_method, "#{key}?") { on? key }
    end

  end

end
