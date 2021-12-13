class Api::V1::CurrentUserController < Api::V1::ApiController
  
  # GET /api/v1/current_user/info
  def info
    user_json = UserSerializer.new(current_user).as_json
    render json: { user: user_json }, status: :ok
  end
  
  # PUT/PATCH /api/v1/current_user
  def update
    if current_user.update(user_params)
      user_json = UserSerializer.new(current_user).attributes.as_json
      render json: { user: user_json }, status: :ok
    else
      render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # POST /api/v1/current_user/resend_email_confirmation
  def resend_email_confirmation
    if current_user.confirmed?
      render json: { errors: ['User email has been already confirmed.'] }, status: :unprocessable_entity
      return
    end
    
    current_user.send_confirmation_instructions
    render json: { success: true }, status: :ok
  end
  
  # GET /current_user/settings
  def settings
    settings = Setting.get_setting(current_user)
    settings_json = SettingsSerializer.new(settings).as_json
    render json: { settings: settings_json }, status: :ok
  end
  
  # PUT /current_user/update_push_token
  def device_push_token
    if device_params[:push_token].blank?
      render json: { errors: ['Device push token should be present.'] }, status: :unprocessable_entity
      return
    end
    
    if current_device.update(device_params)
      render json: { success: true }, status: :ok
    else
      render json: { success: false }, status: :ok
    end
  end
  
  # POST /current_user/change_password
  def change_password
    old_password = change_password_params[:old_password]
    password = change_password_params[:password]
    password_confirmation = change_password_params[:password_confirmation]
    
    if old_password.blank? || password.blank? || password_confirmation.blank?
      render json: { errors: ['Password params is empty.'] }, status: :unprocessable_entity
      return
    end
    
    unless current_user.valid_password?(old_password)
      render json: { errors: ['Old password is wrong.'] }, status: :unprocessable_entity
      return
    end
    
    if password != password_confirmation
      render json: { errors: ['The password confirmation does not match.'] }, status: :unprocessable_entity
      return
    end
    
    current_user.password = password
    current_user.password_confirmation = password_confirmation
    if current_user.save
      user_json = UserSerializer.new(current_user).attributes.as_json
      render json: { user: user_json }, status: :ok
    else
      render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  private
    def user_params
      strong_params = params.require(:user).permit(:banner_picture, :birthday, :country_code, :email, :first_name, :last_name, :middle_name, :phone_number, :profile_picture, language_ids: [])
      
      # Change country_code to id
      country_code = strong_params[:country_code]
      if country_code.present?
        strong_params = strong_params.except(:country_code)
        country = Country.find_by(code: country_code)
        strong_params[:country_id] = country.id
      end
      
      strong_params
    end
    
    def device_params
      params.require(:device).permit(:push_token)
    end
    
    def change_password_params
      params.require(:user).permit(:old_password, :password, :password_confirmation)
    end
end
