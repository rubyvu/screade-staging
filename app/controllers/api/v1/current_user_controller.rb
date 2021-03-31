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
end
