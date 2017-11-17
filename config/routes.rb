Rails.application.routes.draw do

  mount Attachinary::Engine => '/attachinary'
  mount ActionCable.server => '/cable'
  mount ForestLiana::Engine => '/forest'

  require "sidekiq/web"
  authenticate :user, lambda { |u| u.admin } do
    mount Sidekiq::Web => '/sidekiq'
  end

  post '/stripe/webhook', to: "stripe#webhook"
  get '/tags' => 'tags#index'

  devise_for :users,
    only: :omniauth_callbacks,
    path: '',
    controllers: {
      omniauth_callbacks: 'users/omniauth_callbacks'
    }

  scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/ do

    root to: 'pages#home'
    get '/advisor', to: 'pages#advisor'
    get '/legal', to: 'pages#legal'
    get '/terms', to: 'pages#terms'
    get '/privacy', to: 'pages#privacy'

    get '/contact', to: 'contact_messages#new', as: 'new_contact_message'
    post '/contact', to: 'contact_messages#create', as: 'contact_messages'


    devise_for :users,
      skip: :omniauth_callbacks,
      path: '',
      path_names: {
        sign_up: 'signup',
        sign_in: 'login',
        sign_out: 'logout'
      },
      controllers: {
        registrations: 'users/registrations',
        confirmations: 'users/confirmations',
        passwords: 'users/passwords'
      }

    devise_scope :user do
      get "confirm", to: "users/registrations#confirm"
      get "password/reset", to: "users/passwords#reset"
    end

    resources :users, only: [:show, :update]

    get 'welcome', to: 'users#welcome'
    get 'dashboard', to: 'users#dashboard'
    get 'details', to: 'users#details'
    get 'bank', to: 'users#bank'
    get 'advising', to: 'users#advising'
    patch 'update_country', to: 'users#update_country'
    patch 'update_bank', to: 'users#update_bank'
    patch 'change_locale', to: 'users#change_locale'

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
