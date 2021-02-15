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
  
  # POST /api/v1/current_user/resend_email_confirmation
  def resend_email_confirmation
    if current_user.confirmed?
      render json: { errors: ['User email has been already confirmed.'] }, status: :unprocessable_entity
      return
    end
      
    current_user.send_confirmation_instructions
    render json: { success: true }, status: :ok
  end
  
  private
    def user_params
      params.require(:user).permit(:banner_picture, :birthday, :country_code, :email, :first_name, :last_name, :middle_name, :phone_number, :profile_picture)
    end
end
