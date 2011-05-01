# Uses cookie to determine feature state.
class Flip::CookieStrategy < Flip::AbstractStrategy

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
    cookies[cookie_name(key)] = on
  end

  def delete! key
    cookies.delete cookie_name(key)
  end

  def self.cookies= cookies
    @@cookies = cookies
  end

  private

  def cookie_name(definition)
    definition = definition.key unless definition.is_a? Symbol
    "flip_#{definition}"
  end

  def cookies
    @@cookies || raise("Cookies not loaded")
  end

  # Include in ApplicationController to push cookies into CookieStrategy.
  module Loader
    extend ActiveSupport::Concern
    included { around_filter :cookie_feature_strategy }
    module InstanceMethods
      def cookie_feature_strategy
        Flip::CookieStrategy.cookies = cookies
        yield
        Flip::CookieStrategy.cookies = nil
      end
    end
  end

end
