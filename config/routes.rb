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
  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }
  
  resources :comments, only: [] do
    member do
      post :lit
      delete :unlit
    end
  end
  
  resources :current_user, only: [] do
    collection do
      put :update
      patch :update
    end
  end
  
  resources :fonts, only: [] do
    collection do
      get :customize
    end
  end
  resources :home, only: [:index]
  resources :news_articles, only: [] do
    member do
      get :comments
      post :lit
      post :create_comment
      post :view
      delete :unlit
    end
  end
  
  resources :news_categories, only: [:show]
  resources :forgot_password, only: [] do
    collection do
      post :security_question
    end
  end
  
  resources :settings, only: [:update]
  resources :user_images, only: [], param: :username, username: User::USERNAME_ROUTE_FORMAT do
    member do
      get :images
      get :webhook
    end
    
    collection do
      delete :destroy
      get :processed_urls
    end
  end
  
  resources :user_videos, only: [], param: :username, username: User::USERNAME_ROUTE_FORMAT do
    member do
      get :videos
      get :webhook
    end
    
    collection do
      delete :destroy
      get :processed_urls
    end
  end
  
  resources :users, only: [:show], param: :username, username: User::USERNAME_ROUTE_FORMAT
  
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
      
      resources :comments, only: [] do
        member do
          post :lit
          delete :unlit
        end
      end
      
      resources :contacts, only: [:create]
      resources :countries, only: [:index]
      resources :current_user, only: [] do
        collection do
          get :info
          put :update
          patch :update
          post :resend_email_confirmation
        end
        
        resources :user_topic_subscriptions, only: [:create, :destroy]
      end
      
      resources :events, only: [:index, :create, :update, :destroy]
      resources :forgot_password, only: [:create] do
        collection do
          get :security_question
        end
      end
      
      resources :groups, only: [:index]
      resources :home, only: [] do
        collection do
          get :news
          get :breaking_news
          get :trends
        end
      end
      
      resources :languages, only: [:index]
      resources :news_articles, only: [:show] do
        resources :news_article_comments, only: [:index, :create]
        member do
          post :lit
          post :view
          delete :unlit
        end
      end
      
      resources :news_articles, only: [] do
        resources :news_article_subscriptions, only: [:create] do
        end
      end
      
      resources :news_categories, only: [:index] do
        member do
          get :news
        end
      end
      
      resources :settings, only: [:index] do
        collection do
          put :update
        end
      end
      resources :squad_requsts, only: [:index, :create] do
        member do
          post :accept
          post :decline
        end
      end
      
      resources :topics, only: [:index, :show, :create]
      resources :user_assets, only: [:images],  param: :username, username: User::USERNAME_ROUTE_FORMAT do
        collection do
          get :upload_url
          post :confirmation
          post :destroy_images
          post :destroy_videos
        end
        
        member do
          get :images
          get :videos
        end
      end
      resources :user_security_questions, only: [:index]
      resources :users, only: [:show], param: :username, username: User::USERNAME_ROUTE_FORMAT
    end
  end
end
