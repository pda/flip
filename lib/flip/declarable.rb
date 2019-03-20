module Flip
  module Declarable

    def self.extended(base)
      FeatureSet.reset
    end

    # Adds a new feature definition, creates predicate method.
    def feature(key, options = {})
      FeatureSet.instance << Flip::Definition.new(key, options)
    end

    # Adds a strategy for determining feature status.
    def strategy(strategy)
      FeatureSet.instance.add_strategy strategy
      ActionController::Base.send(:include, "#{strategy}::Loader".constantize) if [Flip::SessionStrategy, Flip::CookieStrategy].include? strategy
    end

    # The default response, boolean or a Proc to be called.
    def default(default)
      FeatureSet.instance.default = default
    end

  end
end
