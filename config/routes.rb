Rails.application.routes.draw do
  devise_for :users

  root to: 'pages#home'

  get 'secret', to: 'pages#secret', as: :secret
end
