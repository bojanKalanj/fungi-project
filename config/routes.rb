Rails.application.routes.draw do

  devise_for :users, controllers: {
    registrations: 'custom_devise/registrations',
    confirmations: 'custom_devise/confirmations',
    sessions: 'custom_devise/sessions'
  }

  namespace :admin do
    resources :users
    resources :species, param: :url do
      resources :characteristics
    end
    resources :specimens, controller: 'specimens'
    resources :references do
      resources :characteristics
    end
    resources :locations
    resources :languages
    resources :pages
    resources :habitats, only: :index
    resource :dashboard, only: :show, controller: 'dashboard'
    resources :audits, only: [:index, :show]
  end

  resources :statistics, only: :show
  resources :systematics, only: :show

  resources :language_switcher, only: :update, controller: 'language_switcher'

  resources :species, param: :url, only: [:show] do
    get :search, on: :collection
  end

  resources :specimens, controller: 'specimens', only: [:show] do
    get :search, on: :collection
  end

  resources :localized_pages, only: :show, :path => '/'
  root to: 'home#index'

end
