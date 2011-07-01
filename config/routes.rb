Flip::Engine.routes.draw do

  scope module: "Flip" do

    resources :features, path: "", only: [ :index ] do

      resources :strategies,
        only: [ :update, :destroy ]

    end

  end

end
