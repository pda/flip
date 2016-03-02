module Flip
  class Engine < ::Rails::Engine
    isolate_namespace Flip

    initializer "flip.blarg" do
      ActionController::Base.send(:include, Flip::CookieStrategy::Loader)
    end
  end
end
