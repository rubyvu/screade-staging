class UserVideosController < ApplicationController
  before_action :set_user, only: [:videos, :webhook]
  
  # GET /user_videos/:username/videos
  def videos
    @videos = []
    @videos = @user.user_videos.order(updated_at: :desc).page(params[:page]).per(24) if @user.setting.is_videos
    
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
    
    redirect_to videos_user_video_path(username: params[:username])
  end
  
  # DELETE /user_videos/destroy
  def destroy
    user_video = UserVideo.find_by!(user: current_user, id: params[:id])
    user_video.destroy
    redirect_to videos_user_video_path(username: current_user.username)
  end
  
  # GET /user_videos/processed_urls
  def processed_urls
    user_videos = UserVideo.where(id: params[:ids])
    videos_json = ActiveModel::Serializer::CollectionSerializer.new(user_videos, serializer: UserVideoSerializer).as_json
    render json: { videos: videos_json }, status: :ok
  end
  
  private
    def set_user
      @user = User.find_by!(username: params[:username])
    end
end
