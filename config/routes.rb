Rails.application.routes.draw do

  devise_for :users

  resources :users
  resources :species, param: :url
  resources :specimens
  resources :references
  resources :locations
  resources :characteristics, param: :uuid
  resources :languages

  root to: 'users#index'
end
