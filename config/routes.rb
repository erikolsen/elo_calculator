Rails.application.routes.draw do
  resources :players, only: [:index, :show, :create, :new]
  resources :games, only: [:index, :new, :create, :show, :destroy]
  resources :clubs, only: [:new]
  resources :tournaments, only: [:index, :new, :create, :show] do
    resources :matches, only: [:new, :create]
  end

  root 'players#index'
end
