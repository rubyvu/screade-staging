class Api::V1::SettingsController < Api::V1::ApiController
  
  # GET /api/v1/settings
  def index
    setting = Setting.get_setting(current_user)
    setting_json = SettingsSerializer.new(setting).as_json
    render json: { setting: setting_json }, status: :ok
  end
  
  # PUT/PATCH /api/v1/settings
  def update
    setting = Setting.get_setting(current_user)
    if setting.update(setting_params)
      setting_json = SettingsSerializer.new(setting).as_json
      render json: { setting: setting_json }, status: :ok
    else
      render json: { errors: setting.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  private
    def setting_params
      params.require(:setting).permit(:font_family, :font_style, :is_current_location, :is_notification, :is_email, :is_images, :is_videos, :is_posts)
    end
end
