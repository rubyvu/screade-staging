class Api::V1::ApiController < ActionController::Base
  skip_before_action :verify_authenticity_token
  before_action :disable_caching
  before_action :authenticate
  
  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: { errors: ['Record not found.'] }, status: :not_found
  end
  
  def current_user
    @current_user
  end
  
  def current_device
    @current_device
  end
  
  def errors_by_attributes(errors)
    errors_array = []
    errors.each do |error|
      errors_array << { "#{error.attribute}": "#{error.message}"}
    end
     
    errors_array
  end
  
  private
    def authenticate
      # Check access_token presence
      access_token = request.headers['X-Device-Token']
      return if access_token.nil?
      
      # Check if Device with this access_token exists
      @current_device = Device.find_by(access_token: access_token)
      if @current_device.nil?
        render json: { errors: ['Device with this token not found.'] }, status: :unauthorized
        return
      end
      
      # Set User
      @current_user = @current_device.owner
      
      # Check that User is not locked
      if @current_user.access_locked?
        render json: { errors: ['User has been blocked, please contact support.'] }, status: :unauthorized
        return
      end
    end
    
    def disable_caching
      response.headers["Cache-Control"] = "no-cache, no-store"
      response.headers["Pragma"] = "no-cache"
      response.headers["Expires"] = Time.now.httpdate
    end
end
