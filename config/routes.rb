Rails.application.routes.draw do
  resources :players, only: [:index, :show, :create, :new]
  resources :games, only: [:index, :new, :create, :show]

  root 'players#index'
end
