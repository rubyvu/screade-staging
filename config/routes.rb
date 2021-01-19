Rails.application.routes.draw do
  # Web routes
  devise_for :users
  resources :dashboard, only: [:index]
  
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
