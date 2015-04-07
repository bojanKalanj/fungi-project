Rails.application.routes.draw do

  resources :users, param: :uuid

  root to: 'users#index'
end
