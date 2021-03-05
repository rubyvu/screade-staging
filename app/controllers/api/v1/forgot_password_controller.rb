class Api::V1::ForgotPasswordController < Api::V1::ApiController
  skip_before_action :authenticate, only: [:create]
  
  # GET /api/v1/forgot_password/security_question
  def security_question
    user = User.find_by!(email: params[:email])
    
    user_security_question = user.user_security_question
    unless user_security_question
      render json: { errors: ['Record not found.'] }, status: :not_found
    end
    
    security_question_json = UserSecurityQuestionSerializer.new(user_security_question).as_json
    render json: { security_question: security_question_json }, status: :ok
  end
  
  # POST /api/v1/forgot_password
  def create
    user = User.find_by!(email: user_params[:email])
    if user.failed_attempts >= 5
      render json: { errors: ['You have reached the limit of incorrect answers, your profile has been blocked.'] }, status: :forbidden
      return
    end
      
    security_question = UserSecurityQuestion.find_by!(question_identifier: security_question_params[:question_identifier])
    
    if user.user_security_question == security_question && user.security_question_answer == security_question_params[:security_question_answer]
      # Generate random, long password that the user will never know
      new_password = Devise.friendly_token(50)
      user.reset_password(new_password, new_password)
      
      # Send instructions so user can enter a new password
      user.send_reset_password_instructions
      
      render json: { success: true }, status: :ok
    else
      user.increment_failed_attempts
      user.lock_access! if user.failed_attempts >= 5
      render json: { errors: ['Record not found.'] }, status: :not_found
    end
  end
  
  private
    def user_params
      params.require(:user).permit(:email)
    end
    
    def security_question_params
      params.require(:security_question).permit(:question_identifier, :security_question_answer)
    end
end
