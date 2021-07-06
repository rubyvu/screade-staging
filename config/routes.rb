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
  
  resources :chats, param: :access_token do
    resources :chat_video_rooms, only: [:new], param: :name do
      collection do
        get :participant_token
      end
    end
    
    resources :chat_messages, only: [:create] do
      collection do
        get :images
        get :videos
      end
    end
    
    resources :chat_memberships, only: [:index] do
      collection do
        put :unread_messages
      end
    end
    
    member do
      put :update_members
    end
  end
  
  resources :chat_memberships, only: [:update, :destroy]
  resources :comments, only: [] do
    member do
      post :lit
      delete :unlit
    end
  end
  
  resources :contact_us_requests, only: [:new, :create]
  resources :current_user, only: [] do
    collection do
      put :update
      patch :update
    end
  end
  
  resources :events, only: [:index, :edit, :create, :update, :destroy]
  resources :fonts, only: [] do
    collection do
      get :customize
    end
  end
  
  resources :groups, only: [:index] do
    collection do
      get :comments
      get :search
      get :subscriptions
      post :subscribe
      delete :unsubscribe
    end
  end
  resources :home, only: [:index]
  resources :legal_documents, only: [] do
    collection do
      get :terms_and_services
    end
  end
  
  resources :news_articles, only: [] do
    resources :comments, only: [] do
      get :reply_comments
    end
    
    member do
      get :comments
      get :search
      post :lit
      post :create_comment
      post :view
      post :topic_subscription
      delete :unlit
    end
  end
  
  resources :news_categories, only: [:show]
  resources :forgot_password, only: [] do
    collection do
      post :security_question
    end
  end
  
  resources :notifications, only: [:index, :update]
  resources :posts do
    resources :post_comments, only: [:index, :create] do
      get :reply_comments
    end
    
    resources :post_lits, only: [:create] do
      collection do
        delete :destroy
      end
    end
    
    collection do
      get :user_images
    end
  end
  
  resources :searches, only: [:index]
  resources :settings, only: [:edit, :update]
  resources :squad_requests, only: [:index, :create] do
    member do
      post :accept
      post :decline
    end
  end
  
  resources :topics, only: [:new, :create]
  resources :user_images, only: [:update], param: :username, username: User::USERNAME_ROUTE_FORMAT do
    member do
      get :images
      get :webhook
    end
    
    collection do
      delete :destroy
      get :processed_urls
    end
  end
  
  resources :user_videos, only: [:update], param: :username, username: User::USERNAME_ROUTE_FORMAT do
    member do
      get :videos
      get :webhook
    end
    
    collection do
      delete :destroy
      get :processed_urls
    end
  end
  
  resources :users, only: [:show, :edit], param: :username, username: User::USERNAME_ROUTE_FORMAT do
    collection do
      patch :change_password
    end
  
    resources :squad_members, only: [:index]
  end
  
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
      
      resources :chats, only: [:index, :show, :create, :update], param: :access_token do
        resources :chat_messages, only: [:index, :create]
        member do
          put :update_members
        end
        
        resources :chat_memberships, only: [:index] do
          collection do
            get :chat_users
          end
        end
      end
      
      resources :chat_memberships, only: [:update, :destroy]
      resources :comments, only: [:show] do
        member do
          get :reply_comments
          post :lit
          delete :unlit
        end
      end
      
      resources :contact_us_requests, only: [:create]
      resources :countries, only: [:index]
      resources :current_user, only: [] do
        collection do
          get :info
          put :device_push_token
          put :update
          patch :update
          post :resend_email_confirmation
          post :change_password
        end
      end
      
      resources :events, only: [:index, :create, :update, :destroy]
      resources :forgot_password, only: [:create] do
        collection do
          get :security_question
        end
      end
      
      resources :groups, only: [:index] do
        collection do
          get :comments
          post :subscribe
          delete :unsubscribe
        end
      end
      
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
        member do
          get :groups
          post :topic_subscription
        end
      end
      
      resources :news_categories, only: [:index] do
        member do
          get :news
        end
      end
      
      
      resources :notifications, only: [:index, :show, :update] do
        collection do
          put :view_all
        end
      end
      
      resources :posts, only: [:index, :show, :create, :update, :destroy] do
        resources :post_comments, only: [:index, :create]
        
        resources :post_lits, only: [:create] do
          collection do
            delete :destroy
          end
        end
      end
      
      resources :post_groups, only: [:index]
      resources :searches, only: [:index]
      resources :settings, only: [:index] do
        collection do
          put :update
        end
      end
      resources :squad_requests, only: [:index, :create] do
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
      
      resources :user_images, only: [:update]
      resources :user_security_questions, only: [:index]
      resources :user_videos, only: [:update]
      resources :users, only: [:show], param: :username, username: User::USERNAME_ROUTE_FORMAT do
        resources :squad_members, only: [:index]
      end
    end
  end
end
