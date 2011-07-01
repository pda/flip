module Flip
  class StrategiesController < ApplicationController

    include Flip::Engine.routes.url_helpers

    def update
      strategy.switch! feature_key, turn_on?
      redirect_to features_url
    end

    def destroy
      strategy.delete! feature_key
      redirect_to features_url
    end

    private

    def turn_on?
      params[:commit] == "Switch On"
    end

    def feature_key
      params[:feature_id].to_sym
    end

    def strategy
      FeatureSet.instance.strategy(params[:id])
    end

  end
end
