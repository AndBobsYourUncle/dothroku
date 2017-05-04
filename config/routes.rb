Rails.application.routes.draw do
  devise_for :users

  root to: 'pages#home'

  get 'secret', to: 'pages#secret', as: :secret

  get 'authorize', to: 'github#authorize', as: :authorize
  get 'callback', to: 'github#callback', as: :callback

  namespace :docker_api do
    resources :containers do
      member do
        get :stop
        get :start
      end
    end
  end
end
