class SquadMembersController < ApplicationController
  
  # GET /users/:user_username/squad_members
  def index
    user = User.find_by!(username: params[:user_username])
    @squad_members_requests = user.squad_requests_as_receiver.where.not(accepted_at: nil).or(user.squad_requests_as_requestor.where.not(accepted_at: nil)).distinct
  end
end
