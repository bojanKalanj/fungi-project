Rails.application.routes.draw do

  devise_for :users

  resources :users, param: :uuid
  resources :species, param: :uuid

  root to: 'users#index'
end
