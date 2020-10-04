Rails.application.routes.draw do
  resources :ddcs
  resources :brokers
  resources :networks
  devise_for :users
  root to: 'devices#index'

  resources :devices
  resources :users
  resources :mosquitto_accounts
  resources :mosquitto_acls
  resources :provision_requests do
    member do
      get 'accept'
      get 'deny'
      get 'revoke'
    end
  end

  post '/provision', to: 'provision#index'

  get '/cleardb', to: 'admin#clear_db'
  get '/search', to: 'search#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
