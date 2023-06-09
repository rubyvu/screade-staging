class Api::V1::SquadMembersController < Api::V1::ApiController
  
  # GET /api/v1/users/:user_username/squad_members
  def index
    user = User.find_by!(username: params[:user_username])
    squad_members_requests = user.squad_requests_as_receiver.where.not(accepted_at: nil).or(user.squad_requests_as_requestor.where.not(accepted_at: nil)).distinct.page(params[:page]).per(30)
    squad_members_requests_json = ActiveModel::Serializer::CollectionSerializer.new(squad_members_requests, serializer: SquadRequestSerializer, current_user: current_user).as_json
    render json: { squad_members_requests: squad_members_requests_json }, status: :ok
  end
end
