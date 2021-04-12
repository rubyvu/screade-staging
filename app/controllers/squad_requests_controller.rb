class SquadRequestsController < ApplicationController
  before_action :set_squad_request, only: [:accept, :decline]
  
  # GET /squad_requests
  def index
    @squad_requests_as_receiver = current_user.squad_requests_as_receiver.where(accepted_at: nil, declined_at: nil).page(params[:page]).per(30)
  end
  
  # POST /api/v1/squad_requests
  def create
    receiver = User.find_by!(username: squad_request_params[:receiver_username])
    exists_squad_request = SquadRequest.where(receiver: receiver, requestor: current_user).or(SquadRequest.where(receiver: current_user, requestor: receiver)).first
    
    if exists_squad_request.present?
      squad_request = exists_squad_request
      
      # Change roles in existing Squad requests
      if current_user == squad_request.receiver
        squad_request.receiver = receiver
        squad_request.requestor = current_user
      end
      
      squad_request.accepted_at = nil
      squad_request.declined_at = nil
    else
      squad_request = SquadRequest.new(requestor: current_user, receiver: receiver)
    end
    
    squad_request.save!
    if params[:is_curent_user] == 'true'
      redirect_to user_path(receiver.username)
    else
      redirect_to squad_requests_path
    end
  end
  
  # POST /api/v1/squad_requests/:id/accept
  def accept
    @squad_request.update_columns(accepted_at: DateTime.current, declined_at: nil)
    redirect_to user_squad_members_path(current_user.username)
  end
  
  # POST /api/v1/squad_requests/:id/decline
  def decline
    @squad_request.update_columns(accepted_at: nil, declined_at: DateTime.current)
    
    if params[:is_curent_user] == 'true'
      @squad_request.requestor == current_user ? user = @squad_request.receiver : user = @squad_request.requestor
      redirect_to user_path(user.username)
    else
      redirect_to user_squad_members_path(current_user.username)
    end
  end
  
  private
    def squad_request_params
      params.require(:squad_request).permit(:receiver_username)
    end
    
    def set_squad_request
      @squad_request = SquadRequest.find(params[:id])
    end
end
