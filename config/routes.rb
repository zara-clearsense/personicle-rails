Rails.application.routes.draw do
  
  get 'sessions/new'
  get 'sessions/create'
  get 'sessions/destroy'
  get 'home/index'
  
  # devise_for :users
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  get '/logout', :to => 'sessions#destroy'
  get '/login', :to => 'sessions#new', :as => :login
  resources :users
  root to: 'pages#login'

   # devise_for :dashboard
   resources :dashboard
   namespace :charts do
    get "user-mobility"
   end

  get 'pages/dashboard', :to => 'dashboard#index'
  get 'pages/connections'
  get 'pages/profile', :to => 'profile#index'
  get 'pages/tables'
  get 'pages/login'
  get 'pages/register'
  get 'pages/upgrade'
end
