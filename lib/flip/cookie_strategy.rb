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
    module Loader
      extend ActiveSupport::Concern
      included { around_filter :cookie_feature_strategy }
      def cookie_feature_strategy
        CookieStrategy.cookies = cookies
        yield
        CookieStrategy.cookies = nil
      end
    end

  end
end
