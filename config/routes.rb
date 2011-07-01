Flip::Engine.routes.draw do

  scope module: "Flip" do

    resources :features, path: "/", only: [ :index ] do

      resources :feature_strategies,
        only: [ :update, :destroy ]

    end

  end

end
