Flip::Engine.routes.draw do

  root to: "flip/features#index"

  resources :feature_strategies,
    only: [ :update, :destroy ]

end
