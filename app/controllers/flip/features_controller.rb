module Flip
  class FeaturesController < ApplicationController

    def index
      @p = FeaturesPresenter.new(FeatureSet.instance)
    end

    class FeaturesPresenter

      include Flip::Engine.routes.url_helpers

      def initialize(feature_set)
        @feature_set = feature_set
      end

      def strategies
        @feature_set.strategies
      end

      def definitions
        @feature_set.definitions
      end

      def status(definition)
        @feature_set.on?(definition.key) ? "on" : "off"
      end

      def default_status(definition)
        @feature_set.default_for(definition) ? "on" : "off"
      end

      def strategy_status(strategy, definition)
        if strategy.knows? definition
          strategy.on?(definition) ? "on" : "off"
        end
      end

      def switch_url(strategy, definition)
        feature_strategy_path \
          definition.key,
          strategy.name.underscore
      end

    end

  end
end
