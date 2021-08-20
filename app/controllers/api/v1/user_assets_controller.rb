class Api::V1::UserAssetsController < Api::V1::ApiController
  before_action :set_user, only: [:images, :videos]
  
  # GET /api/v1/user_assets/:username/images
  def images
    options = {}
    options[:is_private] = false if (@user == current_user && params[:is_public].present?) || @user != current_user
    
    images_json = ActiveModel::Serializer::CollectionSerializer.new(@user.user_images.where(options).order(updated_at: :desc).page(params[:page]).per(30), serializer: UserImageSerializer).as_json
    render json: { images: images_json }, status: :ok
  end
  
  # GET /api/v1/user_assets/:username/videos
  def videos
    options = {}
    options[:is_private] = false if (@user == current_user && params[:is_public].present?) || @user != current_user
    
    videos_json = ActiveModel::Serializer::CollectionSerializer.new(@user.user_videos.where(options).order(updated_at: :desc).page(params[:page]).per(30), serializer: UserVideoSerializer).as_json
    render json: { videos: videos_json }, status: :ok
  end
  
  # POST /api/v1/user_assets/destroy_images
  def destroy_images
    images = current_user.user_images.where(id: user_image_params[:ids])
    images.destroy_all
    render json: { success: true }, status: :ok
  end
  
  # POST /api/v1/user_assets/destroy_videos
  def destroy_videos
    videos = current_user.user_videos.where(id: user_video_params[:ids])
    videos.destroy_all
    render json: { success: true }, status: :ok
  end
  
  private
    def set_user
      @user = User.find_by!(username: params[:username])
    end
    
    def confirmation_params
      params.require(:confirmation).permit(:key, :uploader_id)
    end
    
    def user_image_params
      params.require(:user_image).permit(ids: [])
    end
    
    def user_video_params
      params.require(:user_video).permit(ids: [])
    end
end
