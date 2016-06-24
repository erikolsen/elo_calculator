Rails.application.routes.draw do
  resources :players, only: [:index, :show, :create, :new]
  resources :games, only: [:index, :new, :create, :show, :destroy]
  resources :matchups, only: [:new, :create, :show, :edit, :update, :destroy]
  resources :tournaments, only: [:index, :new, :update, :create, :show]
  resources :clubs, only: [:new, :create] do
    scope module: :clubs do
      resources :memberships, only: [:new, :create]
    end
  end
  resources :clubs, only: :show, param: :slug

  root 'clubs#index'
end
