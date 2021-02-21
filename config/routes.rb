Rails.application.routes.draw do
  devise_for :users
  root 'pages#home'
  get 'pages/home'
  get 'pages/about', as: :about
  get 'pages/privacy', as: :privacy
  get '/explore', to: 'pages#explore'
  get '/settings', to: 'settings#root'
  get '/settings/mutes', to: 'settings#mutes'
  get '/auth/twitter/callback', to: 'twitters#create'
  post '/auth/twitter/callback', to: 'twitters#create'
  delete '/auth/twitter', to: 'twitters#destroy'
  get '/notifications', to: 'notifications#index'
  get '/notification/refresh', to: 'notifications#refresh'
  get '/nweets/recommend', to: 'nweets#recommend', as: :recommend

  resources :users, except: [:index], param: :url_digest do
    member do
      get :likes
      get :followers, :followees
    end
    collection do
      patch :tweak
    end
  end

  resources :nweets, except: [:index], param: :url_digest
  resource :tag, only: [:create, :destroy]
  resource :like, only: [:create, :destroy]
  resource :link, only: [:create]
  resource :censoring, only: [:create, :destroy]
  resource :preferring, only: [:create, :destroy]
  resource :relationship, only: [:create, :destroy]
  resource :mute, only: [:create, :destroy]
end
