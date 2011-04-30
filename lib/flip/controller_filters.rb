module Flip::ControllerFilters

  extend ActiveSupport::Concern

  module ClassMethods

    def require_feature key, options = {}
      before_filter options do
        flip_feature_disabled key unless Flip.on? key
      end
    end

  end

  def flip_feature_disabled key
    # TODO: handle this with a 404
  end

end
