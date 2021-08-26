class UserImagesController < ApplicationController
  before_action :set_user, only: [:images]
  
  # GET /user_images/:username
  def images
    options = {}
    options[:is_private] = false if @user != current_user
    @images = @user.user_images.where(options).order(updated_at: :desc).page(params[:page]).per(24)
    @image_uploader = nil
    @image_uploader = UserImage.new if @user == current_user
  end
  
  # POST /user_images/
  def create
    user_image = UserImage.new(user_image_params)
    user_image.user = current_user
    user_image.save
    redirect_to images_user_image_path(username: current_user.username)
  end
  
  # PUT/PATCH /user_images/:id
  def update
    user_image = UserImage.find(params[:id])
    user_image.update(user_image_params)
    redirect_to images_user_image_path(username: current_user.username)
  end
  
  # DELETE /user_images/destroy
  def destroy
    user_image = UserImage.find_by!(user: current_user, id: params[:id])
    user_image.destroy
    redirect_to images_user_image_path(username: current_user.username)
  end
  
  private
    def set_user
      @user = User.find_by!(username: params[:username])
    end
    
    def user_image_params
      params.require(:user_image).permit(:file, :is_private)
    end
end
