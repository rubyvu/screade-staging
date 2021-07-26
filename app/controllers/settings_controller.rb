class SettingsController < ApplicationController
  
  # GET /settings/:id
  def edit
    @setting = Setting.get_setting(current_user)
  end
  
  # PUT/PATCH /settings
  def update
    settings = current_user.setting
    if settings.id != params[:id].to_i
      redirect_back fallback_location: root_path
      return
    end
    
    if settings.update(settings_params)
      case params[:redirect_path]
      when 'map'
        redirect_to maps_path
      else
        redirect_to user_path(username: current_user.username)
      end
    else
      redirect_back fallback_location: root_path
    end
  end
  
  private
    def settings_params
      params.require(:setting).permit(:font_family, :font_style, :is_current_location, :is_notification, :is_email, :is_images, :is_videos, :is_posts)
    end
end
