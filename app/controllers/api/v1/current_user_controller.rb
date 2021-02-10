class Api::V1::CurrentUserController < Api::V1::ApiController
  
  # PUT/PATCH /api/v1/current_user
  def update
    if current_user.update(user_params)
      user_json = UserSerializer.new(current_user).attributes.as_json
      render json: { user: user_json }, status: :ok
    else
      render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  private
    def user_params
      params.require(:user).permit(:birthday, :country_code, :email, :last_name, :phone_number, :profile_picture)
    end
end
