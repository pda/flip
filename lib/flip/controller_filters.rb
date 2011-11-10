module Flip
  module ControllerFilters

    extend ActiveSupport::Concern

    module ClassMethods

      def require_feature key, options = {}
        before_filter options do
          flip_feature_disabled key unless Flip.on? key
        end
      end

    end

    def flip_feature_disabled key
      raise Flip::Forbidden.new(key)
    end

  end
end
