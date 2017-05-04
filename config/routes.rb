Rails.application.routes.draw do
  devise_for :users

  root to: 'pages#home'

  get 'secret', to: 'pages#secret', as: :secret

  namespace :docker_api do
    resources :containers do
      member do
        get :stop
        get :start
      end
    end
  end
end
