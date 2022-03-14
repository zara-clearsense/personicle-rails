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

  get 'pages/dashboard', :to => 'dashboard#index'
  get 'pages/icons'
  get 'pages/profile', :to => 'profile#index'
  get 'pages/tables'
  get 'pages/login'
  get 'pages/register'
  get 'pages/upgrade'
end
