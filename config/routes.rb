Rails.application.routes.draw do
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Devise authentication
  devise_for :users

  # Static pages
  get "about" => "pages#about", as: :about
  root "pages#home"

  # Shareable blueprint URLs: /@username/slug
  get "@:user_slug/:id" => "blueprints#share", as: :shared_blueprint

  # Blueprint CRUD
  resources :blueprints do
    member do
      post :duplicate
    end
    collection do
      get :search
    end
  end

  # API v1 — JSON endpoints for CLI consumption
  namespace :api do
    namespace :v1 do
      resources :blueprints, only: [ :index, :show, :create, :update, :destroy ] do
        member do
          get :download_script
          get :download_yaml
        end
      end
      devise_scope :user do
        post "login" => "sessions#create", as: :login
        delete "logout" => "sessions#destroy", as: :logout
      end
    end
  end
end
