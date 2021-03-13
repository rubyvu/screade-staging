class Api::V1::SquadRequestsController < Api::V1::ApiController
  before_action :set_squad_request, only: [:accept, :decline]
  # GET /api/v1/squad_requests
  def index
    squad_requests_as_receiver = current_user.squad_requests_as_receiver.where(accepted_at: nil, declined_at: nil)
    squad_requests_json = ActiveModel::Serializer::CollectionSerializer.new(squad_requests_as_receiver, serializer: SquadRequestSerializer).as_json
    render json: { squad_requests: squad_requests_json }, status: :ok
  end
  
  # POST /api/v1/squad_requests
  def create
    receiver = User.find_by!(username: receiver_username)
    exists_squad_request = SquadRequest.where(receiver: receiver, requestor: current_user).or(receiver: current_user, requestor: receiver).first
    
    if exists_squad_request.present?
      squad_request = exists_squad_request
      
      # Change roles in existing Squad requests
      if curent_user == squad_request.receiver
        squad_request.reciver = receiver
        squad_request.requestor = current_user
      end
      
      squad_request.accepted_at = nil
      squad_request.declined_at = nil
    else
      squad_request = SquadRequst.new(requestor: current_user, receiver: receiver)
    end
    
    if squad_request.save
      squad_request_json = SquadRequestSerializer.new(squad_request).as_json
      render json: { squad_request: squad_request_json }, status: :ok
    else
      render json: { errors: squad_request.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # POST /api/v1/squad_requests/:id/accept
  def accept
    @squad_request.update_columns(accepted_at: DateTime.current, declined_at: nil)
    squad_request_json = SquadRequestSerializer.new(@squad_request).as_json
    render json: { squad_request: squad_request_json }, status: :ok
  end
  
  # POST /api/v1/squad_requests/:id/decline
  def decline
    @squad_request.update_columns(declined_at: DateTime.current)
    squad_request_json = SquadRequestSerializer.new(@squad_request).as_json
    render json: { squad_request: squad_request_json }, status: :ok
  end
  
  private
    def squad_request_params
      params.require(:squad_request).permit(:receiver_username)
    end
    
    def set_squad_request
      @squad_request = SquadRequst.find(params[:id])
    end
end
