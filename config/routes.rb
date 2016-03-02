Flip::Engine.routes.draw do
  resources :features, path: "", only: [ :index ] do
    resources :strategies,
      only: [ :update, :destroy ]
  end
end
