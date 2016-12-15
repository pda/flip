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
      cookie = cookies[cookie_name(definition)]
      cookie_value = cookie.is_a?(Hash) ? cookie['value'] : cookie
      cookie_value === 'true'
    end

    def switchable?
      true
    end

    def switch! key, on
      cookies[cookie_name(key)] = {
        'value' => (on ? "true" : "false"),
        'domain' => :all
      }
    end

    def delete! key
      cookies.delete cookie_name(key)
    end

    def self.cookies= cookies
      Thread.current[:flip_cookies] = cookies
    end

    def cookie_name(definition)
      definition = definition.key unless definition.is_a? Symbol
      "flip_#{definition}"
    end

    private

    def cookies
      Thread.current[:flip_cookies] || {}
    end

    # Include in ApplicationController to push cookies into CookieStrategy.
    # Uses before_action and after_action rather than around_action to
    # avoid pointlessly adding to stack depth.
    module Loader
      extend ActiveSupport::Concern
      included do
        before_action :flip_cookie_strategy_before
        after_action :flip_cookie_strategy_after
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
