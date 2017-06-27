Rails.application.routes.draw do

  ActiveAdmin.routes(self)
  mount Attachinary::Engine => "/attachinary"
  mount ActionCable.server => '/cable'

  # Sidekiq Web UI, only for admins.
  require "sidekiq/web"
  authenticate :user, lambda { |u| u.admin } do
    mount Sidekiq::Web => '/sidekiq'
  end

  post '/stripe/webhook', to: "stripe#webhook"

  devise_for :users,
    only: :omniauth_callbacks,
    controllers: {
      omniauth_callbacks: 'users/omniauth_callbacks'
    }

  scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/ do

    root to: 'pages#home'
    get '/advisor', to: 'pages#advisor'
    get '/about', to: 'pages#about'
    get '/terms', to: 'pages#terms'

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

    resources :users, only: [:show, :update] do
      collection do
        get 'welcome', to: 'users#welcome'
        get 'dashboard', to: 'users#dashboard'
        get 'details', to: 'users#details'
        get 'bank', to: 'users#bank'
        get 'country', to: 'users#country'
        patch 'update_country', to: 'users#update_country'
        patch 'update_bank', to: 'users#update_bank'
        patch 'change_locale', to: 'users#change_locale'
      end
    end

    resources :offers, only: [:show, :new, :create, :edit, :update], shallow: true do
      resources :deals, only: [:show, :new, :create], path: 'sessions' do
        member do
          get 'proposition', to: 'deals#proposition'
          get 'review', to: 'deals#review'
          patch 'save_proposition', to: 'deals#save_proposition'
          patch 'submit_proposition', to: 'deals#submit_proposition'
          patch 'decline_proposition', to: 'deals#decline_proposition'
          patch 'accept_proposition', to: 'deals#accept_proposition'
          patch 'close', to: 'deals#close'
          patch 'save_review', to: 'deals#save_review'
          patch 'disable_messages', to: 'deals#disable_messages'
          patch 'cancel', to: 'deals#cancel'
        end
        resources :objectives, only: [:create, :update, :destroy]
        resources :messages, only: [:create]
        resources :payments, only: [:create]
      end
      member do
        post 'pin', to: 'offers#pin'
        post 'status', to: 'offers#status'
      end
    end

  end

end
