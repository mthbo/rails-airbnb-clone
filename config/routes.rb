Rails.application.routes.draw do

  mount Attachinary::Engine => "/attachinary"

  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  devise_for :users
  resources :users, only: [:show]

  resources :offers do
    resources :deals, only: [:show, :new, :create, :edit, :update]
  end

end
