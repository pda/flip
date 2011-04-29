module Flip::ControllerFilters

  extend ActiveSupport::Concern

  module ClassMethods

    def require_feature(key, options = {})
      before_filter options do
        render_not_found unless Flip.on? key
      end
    end

  end

end
