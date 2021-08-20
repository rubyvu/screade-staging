class Api::V1::UserImagesController < Api::V1::ApiController
  
  # POST /api/v1/user_images/
  def create
    user_image = UserImage.new(user_image_params)
    user_image.user = current_user
    
    if user_image.save
      user_image_json = UserImageSerializer.new(user_image).as_json
      render json: { user_image: user_image_json }, status: :ok
    else
      render json: { errors: user_image.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # PUT/PATCH /api/v1/user_images/:id
  def update
    user_image = UserImage.find(params[:id])
    if user_image.update(user_image_params)
      user_image_json = UserImageSerializer.new(user_image).as_json
      render json: { user_image: user_image_json }, status: :ok
    else
      render json: { errors: user_image.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  private
    def user_image_params
      params.require(:user_image).permit(:file, :is_private)
    end
end
