Rails.application.routes.draw do
  resources :players, only: [:index, :show, :create, :new]
  resources :games, only: [:index, :new, :create, :show, :destroy]
  resources :clubs, only: [:new]

  #### Facebook Auth
  match 'auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  match 'auth/failure', to: redirect('/'), via: [:get, :post]
  match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]

  root 'players#index'
end
