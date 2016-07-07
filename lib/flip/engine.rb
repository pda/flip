module Flip
  class Engine < ::Rails::Engine
    isolate_namespace Flip

    initializer "flip.blarg" do
      ActionController::Base.send(:include, Flip::CookieStrategy::Loader)
    end

    initializer "flip.assets.precompile" do |app|
      app.config.assets.precompile += %w(flip.css)
    end
  end
end
