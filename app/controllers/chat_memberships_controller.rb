class ChatMembershipsController < ApplicationController
  before_action :get_chat, only: [:index]
  before_action :get_chat_membership, only: [:update, :destroy]
  
  # GET /chats/:chat_access_token/chat_memberships
  def index
    squad_receivers_sql = User.joins(:squad_requests_as_receiver).where(squad_requests_as_receiver: { requestor: current_user }).where.not(squad_requests_as_receiver: { accepted_at: nil }).to_sql
    squad_requestors_sql = User.joins(:squad_requests_as_requestor).where(squad_requests_as_requestor: { receiver: current_user }).where.not(squad_requests_as_requestor: { accepted_at: nil }).to_sql
    chat_users_sql = User.joins(:chat_memberships).where(chat_memberships: { chat: @chat }).where.not(chat_memberships: { user: current_user }).to_sql
    @squad_members = User.from("(#{squad_receivers_sql} UNION #{squad_requestors_sql} UNION #{chat_users_sql}) AS users")
    
    respond_to do |format|
      case params[:response_type]
      when 'roles'
        format.js { render 'index_roles', layout: false }
      else
        format.js { render 'index', layout: false }
      end
    end
  end
  
  # PUT/PATCH /chat_memberships/:id
  def update
    current_user_membership = ChatMembership.find_by(user: current_user, chat: @chat_membership.chat)
    if current_user_membership.blank?
      render json: { errors: ['Record not found.'] }, status: :not_found
      return
    end
    
    if current_user_membership.role != 'owner'
      render json: { errors: ['Can be changed only by Owner.'] }, status: :unprocessable_entity
      return
    end
    
    @chat_membership.history_cleared_at = DateTime.current if params[:chat_membership][:is_history_cleared]
    if @chat_membership.update(memberships_params)
      render json: { success: true }, status: :ok
    else
      render json: { errors: @chat_membership.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # DELETE /chat_memberships/:access_token
  def destroy
    if @chat_membership.destroy
      render json: { success: true }, status: :ok
    else
      render json: { errors: @chat_membership.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  private
    def get_chat
      @chat = Chat.find_by!(access_token: params[:chat_access_token])
    end
    
    def get_chat_membership
      @chat_membership = ChatMembership.find_by!(id: params[:id])
    end
    
    def memberships_params
      strong_params = params.require(:chat_membership).permit(:role, :is_history_cleared)
      strong_params.delete(:is_history_cleared)
      strong_params
    end
end
