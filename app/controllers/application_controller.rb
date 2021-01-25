class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:birthday, :first_name, :last_name, :phone_number, :profile_picture, :security_question_answer, :username, :user_security_question_id])
    end
end
