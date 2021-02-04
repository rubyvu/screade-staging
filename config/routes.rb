require 'que/web'

Rails.application.routes.draw do
  root to: 'dashboard#index'
  
  # Admin panel routes
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  # Que web panel
  authenticate :admin_user do
    mount Que::Web, at: 'admin/que'
  end
  
  # Web routes
  devise_for :users, controllers: { passwords: 'users/passwords' }
  resources :dashboard, only: [:index]
  resources :news_categories, only: [:show]
  
  # API routes
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      
      resources :news_articles, only: [:show]
      resources :authentication, only: [] do
        collection do
          post :sign_in
          post :sign_up
          delete :sign_out
        end
      end
      
      resources :home, only: [] do
        collection do
          get :news
          get :breaking_news
          get :trends
        end
      end
    end
  end
end
