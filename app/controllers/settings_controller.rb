class SettingsController < ApplicationController
  
  # PUT/PATCH /settings
  def update
    settings = current_user.setting
    if settings.id != params[:id].to_i
      redirect_back fallback_location: root_path
      return
    end
    
    if settings.update(settings_params)
      redirect_to root_path
    else
      redirect_back fallback_location: root_path
    end
  end
  
  private
    def settings_params
      params.require(:setting).permit(:font_family, :font_style)
    end
end
