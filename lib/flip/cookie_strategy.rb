# Uses cookie to determine feature state.
module Flip
  class CookieStrategy < AbstractStrategy

    def description
      "Uses cookies to apply only to your session."
    end

    def status definition
      cookie = cookies.fetch(cookie_name(definition), nil)
      cookie == 'true' if cookie
    end

    def switchable?
      true
    end

    def switch! key, on
      cookies[cookie_name(key)] = {
        value: (on ? "true" : "false"),
        domain: :all
      }
    end

    def delete! key
      cookies.delete(cookie_name(key), domain: :all)
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
