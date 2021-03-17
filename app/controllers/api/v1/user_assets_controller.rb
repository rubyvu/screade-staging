class Api::V1::UserAssetsController < Api::V1::ApiController
  before_action :set_user, only: [:images, :videos]
  
  # GET /api/v1/user_assets/:username/images
  def images
    images_json = ActiveModel::Serializer::CollectionSerializer.new(@user.user_images.order(updated_at: :desc).page(params[:page]).per(30), serializer: UserImageSerializer).as_json
    render json: { images: images_json }, status: :ok
  end
  
  # GET /api/v1/user_assets/:username/videos
  def videos
    videos_json = ActiveModel::Serializer::CollectionSerializer.new(@user.user_videos.where.not("file is NULL").order(updated_at: :desc).page(params[:page]).per(30), serializer: UserVideoSerializer).as_json
    render json: { videos: videos_json }, status: :ok
  end
  
  # GET /api/v1/user_assets/upload_url
  def upload_url
    filename = params[:filename]
    if filename.blank?
      render json: { errors: ['Filename should be present.']}, status: :bad_request
      return
    end
    
    store_path = "uploads/#{SecureRandom.uuid}/#{filename}"
    asset_type = store_path.split('.').last
    if UserImage::IMAGE_RESOLUTIONS.include?(asset_type)
      uploader = UserImage.new(user: current_user)
    elsif UserVideo::VIDEO_RESOLUTIONS.include?(asset_type)
      uploader = UserVideo.new(user: current_user)
    else
      render json: { errors: ['Wrong file format.']}, status: :unprocessable_entity
      return
    end
    
    url = Tasks::AwsS3Api.set_presigned_url(store_path, uploader.file)
    if url.present? && uploader.save
      render json: { url: url, key: store_path, uploader_id: uploader.id }, status: :ok
    else
      render json: { errors: ['Failed to generate image upload url.'] }, status: :unprocessable_entity
    end
  end
  
  # POST /api/v1/user_assets/confirmation
  def confirmation
    key = confirmation_params[:key]
    if key.blank?
      render json: { errors: ['Key should be present.']}, status: :bad_request
      return
    end
    
    asset_type = key.split('.').last
    uploader_id = confirmation_params[:uploader_id]
    if UserImage::IMAGE_RESOLUTIONS.include?(asset_type)
      asset_uploader = UserImage.find(uploader_id)
    elsif UserVideo::VIDEO_RESOLUTIONS.include?(asset_type)
      asset_uploader = UserVideo.find(uploader_id)
    else
      render json: { errors: ['Wrong key format.']}, status: :bad_request
      return
    end
    
    CreateUserAssetsJob.perform_later(asset_uploader.class.name, asset_uploader.id, key)
    render json: { success: true }, status: :ok
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
