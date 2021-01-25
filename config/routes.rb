Rails.application.routes.draw do
  # Admin panel routes
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  # Web routes
  root to: 'dashboard#index'
  devise_for :users, controllers: { passwords: 'users/passwords' }
  resources :dashboard, only: [:index]
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
    end
  end
  
end
