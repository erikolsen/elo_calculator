Rails.application.routes.draw do
  resources :players, only: [:index, :show, :create, :new] do
    resource :accounts, only: [:new, :create], module: 'players'
  end
  resources :games, only: [:index, :new, :create, :show, :destroy]
  resources :clubs, only: [:new]

  root 'homepage#show'
end
