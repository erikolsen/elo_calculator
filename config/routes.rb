Rails.application.routes.draw do
  resources :players, only: [:index, :show, :create, :new]
  resources :games, only: [:index, :new, :create, :show, :destroy]
  resources :clubs, only: [:new]
  match 'auth/:provider/callback', to: 'sessions#create'
  match 'auth/failure', to: redirect('/players/new')
  match 'signout', to: 'sessions#destroy', as: 'signout'

  root 'players#index'
end
