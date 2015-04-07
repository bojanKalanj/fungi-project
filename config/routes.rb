Rails.application.routes.draw do

  resources :users, param: :uuid

end
