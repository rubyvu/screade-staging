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
  
  # Webhooks
  namespace :webhooks do
    resources :twilio, only: [] do
      collection do
        post :status_callback
      end
    end
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
        put :complete
        put :update_participants_counter
      end
    end
    
    resources :chat_audio_rooms, only: [:new], param: :name do
      collection do
        put :complete
        put :update_participants_counter
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
        get :audio_room
        get :video_room
        put :mute
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
  
  resources :maps, only: [:index]
  
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
    
    get :user_images, on: :collection
  end
  
  resources :searches, only: [:index]
  resources :shared_records, only: [:index, :create]
  resources :settings, only: [:edit, :update]
  
  resources :streams, only: [:index, :show, :destroy], param: :access_token do
    resources :stream_comments, only: [:create]
    
    resources :stream_lits, only: [:create] do
      collection do
        delete :destroy
      end
    end
  end
  resources :squad_requests, only: [:index, :create] do
    member do
      post :accept
      post :decline
    end
  end
  
  resources :topics, only: [:new, :create]
  resources :user_images, only: [:create, :update], param: :username, username: User::USERNAME_ROUTE_FORMAT do
    member do
      get :images
    end
    
    collection do
      delete :destroy
    end
  end
  
  resources :user_videos, only: [:create, :update], param: :username, username: User::USERNAME_ROUTE_FORMAT do
    member do
      get :videos
    end
    
    collection do
      delete :destroy
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
        resources :chat_audio_rooms, only: [:create]
        resources :chat_video_rooms, only: [:create]
        resources :chat_messages, only: [:index, :create]
        resources :chat_memberships, only: [:index] do
          collection do
            get :chat_users
            put :mute
            put :unread_messages
          end
        end
        
        put :update_members, on: :member
        post :direct_message, on: :collection
      end
      
      resources :chat_memberships, only: [:update, :destroy]
      
      resources :comments, only: [:show, :destroy] do
        member do
          get :lits
          get :reply_comments
          post :lit
          delete :unlit
          post :share
          post :translate
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
      
      resources :direct_uploads do
        collection do
          get :generate_link
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
      
      resources :invitations, only: [:create] do
        post :hide_popup, on: :collection
      end
      
      resources :languages, only: [:index]
      
      resources :news_articles, only: [:show] do
        resources :news_article_comments, only: [:index, :create]
        
        member do
          get :lits
          post :lit
          post :view
          delete :unlit
          post :share
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
          get :unviewed_notifications_count
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
        
        member do
          get :lits
          post :share
          post :translate
        end
      end
      
      resources :post_groups, only: [:index]
      resources :reports, only: [:create]
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
      
      resources :streams, only: [:index, :show, :create, :update, :destroy], param: :access_token do
        member do
          put :complete
        end
        
        resources :stream_comments, only: [:index, :create]
        resources :stream_lits, only: [:create] do
          collection do
            delete :destroy
          end
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
      
      resources :user_blocks, only: [:index, :create, :destroy], param: :user_id
      resources :user_images, only: [:create, :update]
      resources :user_locations, only: [:index, :create]
      resources :user_security_questions, only: [:index]
      resources :user_videos, only: [:create, :update]
      resources :users, only: [:show], param: :username, username: User::USERNAME_ROUTE_FORMAT do
        resources :squad_members, only: [:index]
      end
    end
  end
end
