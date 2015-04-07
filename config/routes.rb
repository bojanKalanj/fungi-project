Rails.application.routes.draw do

  devise_for :users

  resources :users, param: :uuid

  root to: 'users#index'
end
