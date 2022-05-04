Rails.application.routes.draw do
  
  get 'mobility/index'
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

  get 'pages/dashboard', :to => 'dashboard#index'
  get 'pages/connections', :to => 'connection#index'
  get 'pages/profile', :to => 'profile#index'
  get 'pages/foodlog', :to => 'foodlog#index'
  get 'pages/foodlog/data', :to => 'foodlog#get_edamam_data' , :as => 'get_edamam_data' 
  post 'pages/foodlog/log', :to => 'foodlog#log_food', :as => 'log_food'
  get 'pages/mobility', :to => 'mobility#index'
  # get 'pages/foodlog/recipes', :to => 'foodlog#render'
  get 'pages/login'
  get 'pages/register'
  # get 'pages/recipes'
end
