# Uses session to determine feature state.
module Flip
  class SessionStrategy < AbstractStrategy

    def description
      "Uses session cookie to apply only to your session."
    end

    def knows? definition
      session.key? session_name(definition)
    end

    def on? definition
      feature = session[session_name(definition)]
      feature_value = feature.is_a?(Hash) ? feature['value'] : feature
      feature_value === 'true'
    end

    def switchable?
      true
    end

    def switch! key, on
      session[session_name(key)] = on ? "true" : "false"
    end

    def delete! key
      session.delete session_name(key)
    end

    def self.session= session
      @session = session
    end

    def session_name(definition)
      definition = definition.key unless definition.is_a? Symbol
      "flip_#{definition}"
    end

    private

    def session
      result = self.class.instance_variable_get(:@session) || {}
    end

    # Include in ApplicationController to push cookies into CookieStrategy.
    # Users before_filter and after_filter rather than around_filter to
    # avoid pointlessly adding to stack depth.
    module Loader
      extend ActiveSupport::Concern
      included do
        before_filter :flip_session_strategy_before
        after_filter :flip_session_strategy_after
      end
      def flip_session_strategy_before
        SessionStrategy.session = session
      end
      def flip_session_strategy_after
        SessionStrategy.session = nil
      end
    end

  end
end
