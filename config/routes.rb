Rails.application.routes.draw do
  devise_for :users

  root to: 'pages#home'

  get 'secret', to: 'pages#secret', as: :secret

  get 'callback', to: 'github#callback', as: :github_callback

  namespace :docker_api do
    resources :containers do
      member do
        get :stop
        get :start
      end
    end
  end

  resources :apps, except: [:index] do
    member do
      get :authorize
      get :deploy
    end
  end
end
