Rails.application.routes.draw do

  mount Attachinary::Engine => "/attachinary"

  root to: 'pages#home'
  get '/dashboard', to: 'pages#dashboard'

  devise_for :users,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  resources :users, only: [:show]

  resources :offers

  resources :deals, only: [:show, :create, :update]

end
