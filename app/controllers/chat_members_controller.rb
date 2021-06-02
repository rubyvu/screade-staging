class ChatMembersController < ApplicationController
  before_action :get_chat, only: [:index]
  
  # GET /chats/:chat_access_token/chat_members
  def index
    squad_receivers_sql = User.joins(:squad_requests_as_receiver).where(squad_requests_as_receiver: { requestor: current_user }).where.not(squad_requests_as_receiver: { accepted_at: nil }).to_sql
    squad_requestors_sql = User.joins(:squad_requests_as_requestor).where(squad_requests_as_requestor: { receiver: current_user }).where.not(squad_requests_as_requestor: { accepted_at: nil }).to_sql
    @squad_members = User.from("(#{squad_receivers_sql} UNION #{squad_requestors_sql}) AS users")
    
    respond_to do |format|
      case params[:response_type]
      when 'roles'
        format.js { render 'index_roles', layout: false }
      else
        format.js { render 'index', layout: false }
      end
    end
  end
  
  # PUT/PATCH /chat_members/:id
  def update
    chat_membership_to_update = ChatMembership.find_by(id: params[:id])
    if chat_membership_to_update.blank?
      render json: { errors: ['Record not found.'] }, status: :not_found
      return
    end
    
    current_user_membership = ChatMembership.find_by!(user: current_user, chat: chat_membership_to_update.chat)
    if current_user_membership.blank?
      render json: { errors: ['Record not found.'] }, status: :not_found
      return
    end
    
    if current_user_membership.role != 'owner'
      render json: { errors: ['Can be changed only by Owner.'] }, status: :unprocessable_entity
      return
    end
    
    if chat_membership_to_update.update(memberships_params)
      render json: { success: true }, status: :ok
    else
      render json: { errors: chat_membership_to_update.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  private
    def get_chat
      @chat = Chat.find_by!(access_token: params[:chat_access_token])
    end
    
    def memberships_params
      params.require(:chat_membership).permit(:role)
    end
end
