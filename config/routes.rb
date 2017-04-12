Rails.application.routes.draw do

  ActiveAdmin.routes(self)
  mount Attachinary::Engine => "/attachinary"

  mount ActionCable.server => '/cable'

  # Sidekiq Web UI, only for admins.
  require "sidekiq/web"
  authenticate :user, lambda { |u| u.admin } do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users,
    only: :omniauth_callbacks,
    controllers: {
      omniauth_callbacks: 'users/omniauth_callbacks'
    }

  scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/ do

    devise_for :users,
      skip: :omniauth_callbacks,
      controllers: {
        registrations: 'users/registrations',
        confirmations: 'users/confirmations',
        passwords: 'users/passwords'
      }

    devise_scope :user do
      get "users/confirm", to: "users/registrations#confirm"
      get "users/password/reset", to: "users/passwords#reset"
    end

    root to: 'pages#home'
    get '/be_advisor', to: 'pages#be_advisor'

    resources :users, only: [:show]
    get '/dashboard', to: 'users#dashboard'

    resources :offers, only: [:show, :new, :create, :edit, :update], shallow: true do
      resources :deals, only: [:show, :new, :create], path: 'sessions' do
        member do
          get 'new_proposition', to: 'deals#new_proposition'
          get 'new_review', to: 'deals#new_review'
          patch 'save_proposition', to: 'deals#save_proposition'
          patch 'submit_proposition', to: 'deals#submit_proposition'
          patch 'decline_proposition', to: 'deals#decline_proposition'
          patch 'open_session', to: 'deals#open_session'
          patch 'close_session', to: 'deals#close_session'
          patch 'save_review', to: 'deals#save_review'
          patch 'disable_messages', to: 'deals#disable_messages'
          patch 'cancel_session', to: 'deals#cancel_session'
        end
        resources :objectives, only: [:create, :update, :destroy]
        resources :messages, only: [:create]
        resources :payments, only: [:create]
      end
      member do
        post 'pin', to: 'offers#pin'
      end
    end

  end

end
