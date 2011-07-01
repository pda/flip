Flip::Engine.routes.draw do

  scope module: "Flip" do

    root to: "features#index"

    resources :feature_strategies,
      only: [ :update, :destroy ]

  end

end
