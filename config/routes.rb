Rails.application.routes.draw do
  devise_for :players

  resources :players, only: [:index, :show, :create, :new]
  resources :games, only: [:index, :new, :create, :show, :destroy]
  resources :clubs, only: [:new]

  root 'homepage#show'
end
