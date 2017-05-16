require 'resque/server'

Rails.application.routes.draw do
  devise_for :users

  root to: 'pages#home'

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

      resources :app_services
      resources :environment_variables
    end
  end

  mount ActionCable.server, at: '/cable'

  mount Resque::Server.new, :at => "/resque"
end
