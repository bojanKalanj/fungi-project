Rails.application.routes.draw do

  devise_for :users

  resources :users, param: :uuid
  resources :species, param: :uuid
  resources :specimens, param: :uuid
  resources :references, param: :uuid
  resources :locations, param: :uuid
  resources :characteristics, param: :uuid

  root to: 'users#index'
end
