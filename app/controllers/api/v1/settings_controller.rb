class Api::V1::SettingsController < Api::V1::ApiController
  
  # GET /api/v1/settings
  def index
    settings = Setting.get_setting(current_user)
    settings_json = SettingsSerializer.new(settings).as_json
    render json: { settings: settings_json }, status: :ok
  end
  
  # PUT/PATCH /api/v1/settings
  def update
    settings = Setting.get_setting(current_user)
    if settings.update(settings_params)
      settings_json = SettingsSerializer.new(settings).as_json
      render json: { settings: settings_json }, status: :ok
    else
      render json: { errors: settings.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  private
    def settings_params
      params.require(:settings).permit(:font_family, :font_style, :is_notification, :is_images, :is_videos, :is_posts)
    end
end
