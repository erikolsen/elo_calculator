Rails.application.routes.draw do
  resources :players, only: [:index, :show, :create, :new] do
    scope module: :players do
      resources :clubs, only: [:index]
      resources :games, only: [:index]
      resources :ratings, only: [:index]
      resources :tournaments, only: [:index]
    end
  end
  resources :games, only: [:index, :new, :create, :show, :destroy]
  resources :matchups, only: [:new, :create, :show, :edit, :update, :destroy]
  resources :tournaments, only: [:index, :new, :update, :create] do
    scope module: :tournaments do
      resources :entries, only: [:index, :create]
    end
  end
  post 'tournaments/:id/close_registration', to: 'tournaments#close_registration', as: :close_registration
  resources :round_robins, only: [:show]
  resources :single_eliminations, only: [:show]
  resources :clubs, only: [:new, :create, :index] do
    scope module: :clubs do
      resources :memberships, only: [:index, :new, :create]
    end
  end
  resources :clubs, only: :show, param: :slug
  resources :player_stats, only: [:show]

  root 'players#index'
end
