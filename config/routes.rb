Rails.application.routes.draw do

  ActiveAdmin.routes(self)
  mount Attachinary::Engine => "/attachinary"

  mount ActionCable.server => '/cable'

  # Sidekiq Web UI, only for admins.
  require "sidekiq/web"
  authenticate :user, lambda { |u| u.admin } do
    mount Sidekiq::Web => '/sidekiq'
  end

  root to: 'pages#home'
  get '/be_advisor', to: 'pages#be_advisor'

  devise_for :users,
    controllers: {
      omniauth_callbacks: 'users/omniauth_callbacks',
      registrations: 'users/registrations'
    }

  resources :users, only: [:show, :destroy]
  get '/dashboard', to: 'users#dashboard'

  get '/search', to: 'offers#index'

  resources :offers, only: [:show, :new, :create, :edit, :update], shallow: true do
    resources :pinned_offers, only: [:create, :destroy]
    resources :deals, only: [:show, :new, :create], path: 'sessions' do
      member do
        get 'new_proposition', to: 'deals#new_proposition'
        get 'new_review', to: 'deals#new_review'
        patch 'save_proposition', to: 'deals#save_proposition'
        patch 'submit_proposition', to: 'deals#submit_proposition'
        patch 'decline_proposition', to: 'deals#decline_proposition'
        patch 'open', to: 'deals#open'
        patch 'close', to: 'deals#close'
        patch 'save_review', to: 'deals#save_review'
        patch 'disable_messages', to: 'deals#disable_messages'
        patch 'cancel', to: 'deals#cancel'
      end
      resources :objectives, only: [:create, :update, :destroy]
      resources :messages, only: [:create]
      resources :payments, only: [:create]
    end
  end

end
