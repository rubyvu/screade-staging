class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  # Helpers for custom Devise modal views
  helper_method :resource_name, :resource, :devise_mapping, :resource_class
  
  def resource_name
    :user
  end
   
  def resource
    @resource ||= User.new
  end
  
  def resource_class
    User
  end
   
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
  
  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:birthday, :country_id, :email, :first_name, :last_name, :phone_number, :profile_picture, :security_question_answer, :username, :user_security_question_id])
      devise_parameter_sanitizer.permit(:sign_in, keys: [:login, :password])
    end
end
