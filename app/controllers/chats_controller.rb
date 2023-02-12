class ChatsController < ApplicationController
  before_action :get_chat, only: [:show, :edit, :update, :update_members]
  before_action :get_current_user_membership, only: [:show, :edit, :update, :update_members]

  # GET /chats
  def index
    @chats = Chat.joins(:chat_memberships).where(chat_memberships: { user: current_user }).order(updated_at: :desc)
  end

  # GET /chats/:access_token
  def show
    current_page = params[:page]
    @chat_messages = @chat.chat_messages.includes(:user).with_attached_image.with_attached_video.order(created_at: :desc).page(current_page).per(40)

    # Clear unread message counter
    @current_user_membership.update_columns(unread_messages_count: 0)

    respond_to do |format|
      if current_page
        format.js { render 'chat_messages/prepend_messages', layout: false }
      else
        format.js { render 'show', layout: false }
      end
    end
  end

  # GET /chats/new
  def new
    @chat = Chat.new
    squad_receivers_sql = User.joins(:squad_requests_as_receiver).where(squad_requests_as_receiver: { requestor: current_user }).where.not(squad_requests_as_receiver: { accepted_at: nil }).to_sql
    squad_requestors_sql = User.joins(:squad_requests_as_requestor).where(squad_requests_as_requestor: { receiver: current_user }).where.not(squad_requests_as_requestor: { accepted_at: nil }).to_sql
    @squad_members = User.from("(#{squad_receivers_sql} UNION #{squad_requestors_sql}) AS users")

    respond_to do |format|
      format.js { render 'new', layout: false }
    end
  end

  # GET /chats/edit/:access_token
  def edit
    respond_to do |format|
      format.js { render 'edit', layout: false }
    end
  end

  # POST /chats
  def create
    # Initialize new Chat
    chat = Chat.new(owner: current_user)

    # Initialize ChatMembership for Owner
    chat.chat_memberships.build(user: current_user)

    # Initialize ChatMembership for other Users
    User.where(username: memberships_params[:usernames]).each do |user|
      chat.chat_memberships.build(user: user)
    end

    chat.save
    redirect_to chats_path
  end

  # PUT/PATCH /chats/:access_token
  def update
    if @chat.update(chat_params)
      render json: { success: true }, status: :ok
    else
      render json: { errors: @chat.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT /chats/:access_token/update_members
  def update_members
    new_chat_users = User.where(username: memberships_params[:usernames])

    # Add new ChatMembersips to Chat
    new_chat_users.each do |user|
      next if @chat.chat_memberships.exists?(user_id: user.id)
      ChatMembership.create(chat: @chat, user: user)
    end

    respond_to do |format|
      format.js
    end
  end

  # POST /chats/direct_message
  def direct_message
    recipient_id = params.require(:user_id)

    dm_chat_ids = Chat.joins(:chat_memberships).group('chats.id').having('COUNT(chat_memberships.id) = 2').ids

    current_user_chats_ids = ChatMembership.where(user: current_user, chat_id: dm_chat_ids).pluck(:chat_id)
    recipient_chats_ids = ChatMembership.where(user_id: recipient_id, chat_id: dm_chat_ids).pluck(:chat_id)
    latest_dm_chat_id = current_user_chats_ids.intersection(recipient_chats_ids).max

    @chat = Chat.find_by(id: latest_dm_chat_id)

    if @chat
      return redirect_to chats_path(chat_access_token: @chat.access_token)
    end

    # Initialize new Chat
    @chat = Chat.new(owner: current_user)

    # Initialize ChatMembership for Owner
    @chat.chat_memberships.build(user: current_user)

    # Initialize ChatMembership for recipient
    @chat.chat_memberships.build(user_id: recipient_id)

    @chat.save
    redirect_to chats_path(chat_access_token: @chat.access_token)
  end

  private
    def get_chat
      @chat = Chat.find_by!(access_token: params[:access_token])
    end

    def get_current_user_membership
      @current_user_membership = ChatMembership.find_by!(user: current_user, chat: @chat)
    end

    def chat_params
      params.require(:chat).permit(:icon, :name)
    end

    def memberships_params
      params.require(:chat_membership).permit(usernames: [])
    end
end
