class UserImagesController < ApplicationController
  before_action :set_user, only: [:index, :webhook]
  
  # GET /user_images/:username
  def index
    @images = @user.user_images.order(updated_at: :desc).page(params[:page]).per(24)
    
    if @user == current_user
      @image_uploader = UserImage.new.file
      @image_uploader.success_action_redirect = webhook_user_image_url(username: params[:username])
      @image_uploader.policy(enforce_utf8: false)
    else
      @image_uploader = nil
    end
  end
  
  # GET /user_images/:username/webhook
  def webhook
    key = params[:key]
    if key.present? && UserImage::IMAGE_RESOLUTIONS.include?(key.split('.').last)
      new_user_image = UserImage.create(user: current_user)
      CreateUserAssetsJob.perform_later('UserImage', new_user_image.id, key)
    end
    
    redirect_to user_image_path(username: params[:username])
  end
  
  private
    def set_user
      @user = User.find_by!(username: params[:username])
    end
end
