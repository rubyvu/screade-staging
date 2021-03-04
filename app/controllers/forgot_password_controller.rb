class ForgotPasswordController < ApplicationController
  skip_before_action :authenticate_user!, only: [:security_question]
  
  # GET /forgot_password/security_question
  def security_question
    user = User.find_by(email: user_params[:email])
    unless user
      render json: { errors: ['Record not found.'] }, status: :not_found
      return
    end
    
    user_security_question = user.user_security_question
    unless user_security_question
      render json: { errors: ['Record not found.'] }, status: :not_found
      return
    end
    
    security_question_json = UserSecurityQuestionSerializer.new(user_security_question).as_json
    render json: { security_question: security_question_json, email: user.email }, status: :ok
  end
  
  private
    def user_params
      params.require(:user).permit(:email)
    end
end
