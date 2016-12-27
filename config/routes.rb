Rails.application.routes.draw do

  mount Attachinary::Engine => "/attachinary"

  root to: 'pages#home'
  get '/be_advisor', to: 'pages#be_advisor'

  devise_for :users,
    controllers: {
      omniauth_callbacks: 'users/omniauth_callbacks',
      registrations: 'users/registrations'
    }

  resources :users, only: [:show]

  get '/dashboard', to: 'users#dashboard'

  resources :offers, only: [:show, :new, :create, :edit, :update], shallow: true do
    resources :pinned_offers, only: [:create, :destroy]
    resources :deals, only: [:show, :new, :create, :edit, :update] do
      resources :objectives, only: [:create, :update, :destroy]
    end
  end

  get '/search', to: 'offers#index'

end
