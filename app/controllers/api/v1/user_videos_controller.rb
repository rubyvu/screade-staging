class Api::V1::UserVideosController < Api::V1::ApiController
  
  # POST /api/v1/user_videos/
  def create
    user_video = UserVideo.new(user_video_params)
    user_video.user = current_user
    
    if user_video.save
      user_video_json = UserVideoSerializer.new(user_video).as_json
      render json: { user_video: user_video_json }, status: :ok
    else
      render json: { errors: user_video.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # PUT/PATCH /api/v1/user_videos/:id
  def update
    user_video = UserVideo.find(params[:id])
    if user_video.update(user_video_params)
      user_video_json = UserVideoSerializer.new(user_video).as_json
      render json: { user_video: user_video_json }, status: :ok
    else
      render json: { errors: user_video.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  private
    def user_video_params
      params.require(:user_video).permit(:file, :is_private)
    end
end
