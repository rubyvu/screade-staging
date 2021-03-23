class Api::V1::UsersController < Api::V1::ApiController
  
  # GET /api/v1/users/:username
  def show
    user = User.find_by!(username: params[:username])
    user_json = UserProfileSerializer.new(user).as_json
    render json: { user: user_json }, status: :ok
  end
end
