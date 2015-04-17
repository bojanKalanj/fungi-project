Rails.application.routes.draw do

  devise_for :users, controllers: {
    registrations: 'custom_devise/registrations',
    confirmations: 'custom_devise/confirmations',
    sessions: 'custom_devise/sessions'
  }

  namespace :admin do
    resources :users
    resources :species, param: :url
    resources :specimens
    resources :references
    resources :locations
    resources :characteristics, param: :uuid
    resources :languages
    resources :pages
    resource :dashboard, only: :show, controller: 'dashboard'
  end

  localized do
    resources :species, param: :url

    get '/:id' => 'localized_pages#show', :defaults => { :page_id => 1 }
    root to: 'localized_pages#show', :defaults => { :page_id => 1 }, param: :page_id
  end
end
