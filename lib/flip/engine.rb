module Flip
  class Engine < ::Rails::Engine
    engine_name 'flip'
    initializer "flip.blarg" do
      ActionController::Base.send(:include, Flip::CookieStrategy::Loader)
    end
  end
end
