Rails.application.routes.draw do

  mount Attachinary::Engine => "/attachinary"

  root to: 'pages#home'
  get '/dashboard', to: 'pages#dashboard'

  devise_for :users,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  resources :users, only: [:show]

  resources :offers, shallow: true do
    resources :pinned_offers, only: [:create, :destroy]
    resources :deals, only: [:show, :new, :create, :edit, :update] do
      resources :objectives, only: [:create, :update, :destroy]
    end
  end

end
