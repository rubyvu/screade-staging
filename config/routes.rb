require 'que/web'

Rails.application.routes.draw do
  root to: 'home#index'
  
  # Admin panel routes
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  # Que web panel
  authenticate :admin_user do
    mount Que::Web, at: 'admin/que'
  end
  
  # Web routes
  resources :current_user, only: [] do
    collection do
      put :update
      patch :update
    end
  end
  
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
   }
  resources :home, only: [:index]
  resources :news_categories, only: [:show]
  
  # API routes
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :authentication, only: [] do
        collection do
          post :sign_in
          post :sign_up
          delete :sign_out
        end
      end
      
      resources :countries, only: [:index]
      resources :current_user, only: [] do
        collection do
          put :update
          patch :update
        end
      end
      
      resources :forgot_password, only: [:create]
      resources :home, only: [] do
        collection do
          get :news
          get :breaking_news
          get :trends
        end
      end
      
      resources :news_articles, only: [:show]
      resources :user_security_questions, only: [:index]
    end
  end
end
