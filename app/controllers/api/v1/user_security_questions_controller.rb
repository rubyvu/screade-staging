class Api::V1::UserSecurityQuestionsController < Api::V1::ApiController
  skip_before_action :authenticate, only: [:index]
  
  # GET /api/v1/user_security_questions
  def index
    security_questions_json = ActiveModel::Serializer::CollectionSerializer.new(UserSecurityQuestion.all, serializer: UserSecurityQuestionSerializer).as_json
    render json: { security_questions: security_questions_json }, status: :ok
  end
end
