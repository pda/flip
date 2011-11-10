# Uses cookie to determine feature state.
module Flip
  class CookieStrategy < AbstractStrategy

    def description
      "Uses cookies to apply only to your session."
    end

    def knows? definition
      cookies.key? cookie_name(definition)
    end

    def on? definition
      cookies[cookie_name(definition)] === "true"
    end

    def switchable?
      true
    end

    def switch! key, on
      cookies[cookie_name(key)] = on ? "true" : "false"
    end

    def delete! key
      cookies.delete cookie_name(key)
    end

    def self.cookies= cookies
      @cookies = cookies
    end

    def cookie_name(definition)
      definition = definition.key unless definition.is_a? Symbol
      "flip_#{definition}"
    end

    private

    def cookies
      self.class.instance_variable_get(:@cookies) || {}
    end

    # Include in ApplicationController to push cookies into CookieStrategy.
    # Users before_filter and after_filter rather than around_filter to
    # avoid pointlessly adding to stack depth.
    module Loader
      extend ActiveSupport::Concern
      included do
        before_filter :flip_cookie_strategy_before
        after_filter :flip_cookie_strategy_after
      end
      def flip_cookie_strategy_before
        CookieStrategy.cookies = cookies
      end
      def flip_cookie_strategy_after
        CookieStrategy.cookies = nil
      end
    end

  end
end
