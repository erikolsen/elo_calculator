Rails.application.routes.draw do
  resources :players, only: [:index, :show, :create, :new]
  resources :games, only: [:index, :new, :create, :show, :destroy]
  resources :clubs, only: [:new]
  resources :matchups, only: [:new, :create, :show, :edit, :update, :destroy]
  resources :tournaments, only: [:index, :new, :update, :create, :show]

  root 'players#index'
end
