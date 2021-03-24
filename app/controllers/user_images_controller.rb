class UserImagesController < ApplicationController
  before_action :set_user, only: [:images, :webhook]
  
  # GET /user_images/:username
  def images
    @images = []
    @images = @user.user_images.order(updated_at: :desc).page(params[:page]).per(24) if @user.setting.is_images
    
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
    
    redirect_to images_user_image_path(username: params[:username])
  end
  
  # DELETE /user_images/destroy
  def destroy
    user_image = UserImage.find_by!(user: current_user, id: params[:id])
    user_image.destroy
    redirect_to images_user_image_path(username: current_user.username)
  end
  
  # GET /user_images/processed_urls
  def processed_urls
    user_images = UserImage.where(id: params[:ids])
    images_json = ActiveModel::Serializer::CollectionSerializer.new(user_images, serializer: UserImageSerializer).as_json
    render json: { images: images_json }, status: :ok
  end
  
  private
    def set_user
      @user = User.find_by!(username: params[:username])
    end
end
