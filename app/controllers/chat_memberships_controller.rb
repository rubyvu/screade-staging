class ChatMembershipsController < ApplicationController
  before_action :get_chat, only: [:index, :unread_messages]
  before_action :get_chat_membership, only: [:clear_history, :destroy]
  
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
    chat_membership = ChatMembership.find_by(id: params[:id])
    if chat_membership.blank?
      render json: { errors: ['Record not found.'] }, status: :not_found
      return
    end
    
    chat_owner_membership = ChatMembership.find_by(user: current_user, chat: chat_membership.chat)
    if chat_owner_membership.blank?
      render json: { errors: ['Record not found.'] }, status: :not_found
      return
    end
    
    if chat_owner_membership.role != 'owner'
      render json: { errors: ['Can be changed only by Owner.'] }, status: :unprocessable_entity
      return
    end
    
    if chat_membership.update(memberships_params)
      render json: { success: true }, status: :ok
    else
      render json: { errors: chat_membership.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # PUT/PATCH /chat_memberships/:id/clear_history
  def clear_history
    if @chat_membership.update(history_cleared_at: DateTime.current)
      render json: { success: true }, status: :ok
    else
      render json: { errors: @chat_membership.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # PUT/PATCH /chats/:chat_access_token/chat_membership/unread_messages
  def unread_messages
    chat_membership = ChatMembership.find_by(chat: @chat, user: current_user)
    if chat_membership.blank?
      render json: { errors: ['Record not found.'] }, status: :not_found
      return
    end
    
    if chat_membership.update(unread_messages_count: params[:chat_membership][:unread_messages_count])
      render json: { success: true }, status: :ok
    else
      render json: { errors: chat_membership.errors.full_messages }, status: :unprocessable_entity
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
      @chat_membership = ChatMembership.find_by!(id: params[:id], user: current_user)
    end
    
    def memberships_params
      params.require(:chat_membership).permit(:role, :unread_messages_count)
    end
end
