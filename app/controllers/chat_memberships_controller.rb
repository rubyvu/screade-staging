class ChatMembershipsController < ApplicationController
  before_action :get_chat, only: [:audio_room, :index, :mute, :video_room, :unread_messages]
  before_action :get_chat_membership, only: [:destroy]
  
  # GET /chats/:chat_access_token/chat_memberships
  def index
    chat_users_ids = @chat.chat_memberships.pluck(:user_id)
    squad_receivers_sql = User.joins(:squad_requests_as_receiver).where(squad_requests_as_receiver: { requestor: current_user }).where.not(squad_requests_as_receiver: { accepted_at: nil }).where.not(users: { id: chat_users_ids }).to_sql
    squad_requestors_sql = User.joins(:squad_requests_as_requestor).where(squad_requests_as_requestor: { receiver: current_user }).where.not(squad_requests_as_requestor: { accepted_at: nil }).where.not(users: { id: chat_users_ids }).to_sql
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
  
  # GET /chats/:chat_access_token/chat_memberships/audio_room
  def audio_room
    audio_room = @chat.chat_audio_rooms.find_by!(status: 'in-progress')
    participant_usernames = audio_room.participants.map { |participant| participant[1] }
    users = User.where(username: participant_usernames)
    audio_room_members = ActiveModel::Serializer::CollectionSerializer.new(users, serializer: UserProfileSerializer).as_json
    render json: { audio_room_members: audio_room_members }, status: :ok
  end
  
  # GET /chats/:chat_access_token/chat_memberships/video_room
  def video_room
    video_room = @chat.chat_video_rooms.find_by!(status: 'in-progress')
    participant_usernames = video_room.participants.map { |participant| participant[1] }
    users = User.where(username: participant_usernames)
    video_room_members = ActiveModel::Serializer::CollectionSerializer.new(users, serializer: UserProfileSerializer).as_json
    render json: { video_room_members: video_room_members }, status: :ok
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
  
  # PUT/PATCH /chats/:chat_access_token/chat_memberships/unread_messages
  def unread_messages
    chat_membership = ChatMembership.find_by(chat: @chat, user: current_user)
    if chat_membership.blank?
      render json: { errors: ['Record not found.'] }, status: :not_found
      return
    end
    
    # Clear unread message counter
    chat_membership.update_columns(unread_messages_count: 0)
    chat_membership_json = ChatMembershipSerializer.new(chat_membership).as_json
    render json: { chat_membership: chat_membership_json }, status: :ok
  end
  
  # PUT/PATCH /chats/:chat_access_token/chat_memberships/mute
  def mute
    chat_membership = ChatMembership.find_by(chat: @chat, user: current_user)
    if chat_membership.blank?
      render json: { errors: ['Record not found.'] }, status: :not_found
      return
    end
    
    # Clear unread message counter
    chat_membership.update_columns(is_mute: !chat_membership.is_mute)
    chat_membership_json = ChatMembershipSerializer.new(chat_membership).as_json
    render json: { chat_membership: chat_membership_json }, status: :ok
  end
  
  # DELETE /chat_memberships/:id
  def destroy
    current_user_membership = ChatMembership.find_by(user: current_user, chat: @chat_membership.chat)
    if current_user_membership.blank?
      render json: { errors: ['Record not found.'] }, status: :not_found
      return
    end
    
    if ['admin', 'owner'].exclude?(current_user_membership.role) && current_user_membership != @chat_membership
      render json: { errors: ['Can be changed only by Chat admin.'] }, status: :unprocessable_entity
      return
    end
    
    if @chat_membership.destroy
      render json: { success: true, redirect_path: params[:redirect_path] }, status: :ok
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
      params.require(:chat_membership).permit(:role, :unread_messages_count)
    end
end
