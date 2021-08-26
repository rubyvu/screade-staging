class UserVideosController < ApplicationController
  before_action :set_user, only: [:videos]
  
  # GET /user_videos/:username/videos
  def videos
    options = {}
    options[:is_private] = false if @user != current_user
    @videos = @user.user_videos.where(options).order(updated_at: :desc).page(params[:page]).per(24)
    @video_uploader = nil
    @video_uploader = UserVideo.new if @user == current_user
  end
  
  # POST /user_videos/
  def create
    user_video = UserVideo.new(user_video_params)
    user_video.user = current_user
    user_video.save
    redirect_to videos_user_video_path(username: current_user.username)
  end
  
  # PUT/PATCH /user_videos/:id
  def update
    user_video = UserVideo.find(params[:id])
    user_video.update(user_video_params)
    redirect_to videos_user_video_path(username: current_user.username)
  end
  
  # DELETE /user_videos/destroy
  def destroy
    user_video = UserVideo.find_by!(user: current_user, id: params[:id])
    user_video.destroy
    redirect_to videos_user_video_path(username: current_user.username)
  end
  
  private
    def set_user
      @user = User.find_by!(username: params[:username])
    end
    
    def user_video_params
      params.require(:user_video).permit(:file, :is_private)
    end
end
