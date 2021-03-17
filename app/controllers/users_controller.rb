class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  
  def show
    @images = @user.user_images.order(updated_at: :desc).limit(6)
    @videos = @user.user_videos.order(updated_at: :desc).limit(6)
  end
  
  private
    def set_user
      @user = User.find_by!(username: params[:username])
    end
end
