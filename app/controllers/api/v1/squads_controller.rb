class Api::V1::SquadsController < Api::V1::ApiController
  
  # GET /api/v1/user/:username/squads
  def index
    user = User.find_by!(username: params[:username])
    accepted_squad_requests = user.squad_requests_as_receiver.where.not(accepted_at: nil).or(user.squad_requests_as_requestor.where.not(accepted_at: nil)).distinct.page(params[:page]).per(30)
    accepted_squad_requests_json = ActiveModel::Serializer::CollectionSerializer.new(squad_requests_as_receiver, serializer: SquadRequestSerializer).as_json
    render json: { accepted_squad_requests: accepted_squad_requests_json }, status: :ok
  end
end
