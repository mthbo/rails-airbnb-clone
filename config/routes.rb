Rails.application.routes.draw do

  mount Attachinary::Engine => "/attachinary"

  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  devise_for :users,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  resources :users, only: [:show]

  resources :offers do
    # not nested?
    resources :deals, only: [:index, :show, :new, :create, :edit, :update]
  end

  get '/dashboard', to: 'pages#dashboard'

end
