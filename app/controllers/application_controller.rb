class ApplicationController < ActionController::Base
  before_action :redirect_from_apex_to_www
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_location
  before_action :set_time_zone
  
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
  
  def current_location
    cookies[:current_location]
  end
  
  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:birthday, :country_id, :email, :first_name, :last_name, :phone_number, :profile_picture, :security_question_answer, :username, :user_security_question_id])
      devise_parameter_sanitizer.permit(:sign_in, keys: [:login, :password])
    end
    
    def redirect_from_apex_to_www
      if request.host == 'screade.com'
        redirect_to 'https://www.screade.com' + request.fullpath, status: 301
      end
    end
    
    def set_location
      return if cookies[:current_location].present?
      begin
        result = request.location
        cookies[:current_location] = result.country_code&.upcase
      rescue
        puts "[WARNING]: Location request limit reached"
      end
    end
    
    def set_time_zone
      begin
        time_zone_cookies = cookies[:time_zone].to_i
        Time.zone = ActiveSupport::TimeZone[-time_zone_cookies.minutes]
      rescue
        Time.zone = 'UTC'
      end
    end
end
