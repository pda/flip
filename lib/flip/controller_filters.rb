module Flip
  # ControllerFilters is a name that refers to the fact that Rails
  # before_action and after_action used to be before_filter and
  # after_filter.
  module ControllerFilters

    extend ActiveSupport::Concern

    module ClassMethods

      def require_feature key, options = {}
        before_action options do
          flip_feature_disabled key unless Flip.on? key
        end
      end

    end

    def flip_feature_disabled key
      raise Flip::Forbidden.new(key)
    end

  end
end
