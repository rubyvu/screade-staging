class Api::V1::UserAssetsController < Api::V1::ApiController
  
  # GET /api/v1/user_assets/:username/images
  def images
    user = User.find_by!(username: params[:username])
    images_json = ActiveModel::Serializer::CollectionSerializer.new(user.user_images, serializer: UserImageSerializer).as_json
    render json: { images: images_json }, status: :ok
  end
  
  # GET /api/v1/user_assets/:username/videos
  def videos
    user = User.find_by!(username: params[:username])
    videos_json = ActiveModel::Serializer::CollectionSerializer.new(user.user_videos, serializer: UserVideoSerializer).as_json
    render json: { videos: videos_json }, status: :ok
  end
end
