Rails.application.routes.draw do
  devise_for :users
  root 'pages#home'
  get 'pages/home'
  get 'pages/about'
  get '/auth/twitter/callback', :to => 'twitters#create'
  post '/auth/twitter/callback', :to => 'twitters#create'
  delete '/auth/twitter', :to => 'twitters#destroy'
  get '/notifications', :to => 'notifications#index'
  get '/notification/refresh', :to => 'notifications#refresh'
  get '/links/recommend', :to=> 'links#recommend'

  get '/christmas', :to => 'christmas#show', as: 'christmas'

  resources :users, except: [:index], param: :url_digest do
    member do
      get :likes
      get :followers, :followees
    end
  end

  resources :nweets, only: [:create, :update, :destroy, :show], param: :url_digest
  resource :category, only: [:create, :destroy]
  resource :like, only: [:create, :destroy]
  resource :link, only: [:create]
  resource :censoring, only: [:update]
  resource :relationship, only: [:create, :destroy]
end
