class UserVideosController < ApplicationController
  before_action :set_user, only: [:index, :webhook]
  
  # GET /user_videos/:username
  def index
    @videos = @user.user_videos.order(updated_at: :desc).page(params[:page]).per(24)
    
    if @user == current_user
      @video_uploader = UserVideo.new.file
      @video_uploader.success_action_redirect = webhook_user_video_url(username: params[:username])
      @video_uploader.policy(enforce_utf8: false)
    else
      @video_uploader = nil
    end
  end
  
  # GET /user_videos/:username/webhook
  def webhook
    key = params[:key]
    if key.present? && UserVideo::VIDEO_RESOLUTIONS.include?(key.split('.').last)
      new_user_video = UserVideo.create(user: current_user)
      CreateUserAssetsJob.perform_later('UserVideo', new_user_video.id, key)
    end
    
    redirect_to user_video_path(username: params[:username])
  end
  
  # DELETE /user_videos/destroy
  def destroy
    user_video = UserVideo.find_by!(user: current_user, id: params[:id])
    user_video.destroy
    redirect_to user_video_path(username: current_user.username)
  end
  
  private
    def set_user
      @user = User.find_by!(username: params[:username])
    end
end
