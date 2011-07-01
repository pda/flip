module Flip
  class Engine < ::Rails::Engine

    initializer "flip.blarg" do
      ActionController::Base.send(:include, Flip::CookieStrategy::Loader)
    end

  end
end
