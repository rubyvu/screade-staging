class ChatsController < ApplicationController
  before_action :get_chat, only: [:show, :edit, :update, :update_members, :destroy]
  before_action :get_current_user_membership, only: [:show, :edit, :update, :update_members, :destroy]
  
  # GET /chats
  def index
    @chats = Chat.joins(:chat_memberships).where(chat_memberships: { user: current_user }).order(updated_at: :desc)
    @chat = @chats.first
  end
  
  # GET /chats/:access_token
  def show
    respond_to do |format|
      format.js { render 'show', layout: false }
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
    
    # Remove ChatMemberships from Chat
    memberships_to_delete = @chat.chat_memberships.where.not(user_id: new_chat_users.ids).and(@chat.chat_memberships.where.not(user: current_user))
    @chat.chat_memberships.delete(*memberships_to_delete)
    
    respond_to do |format|
      format.js
    end
  end
  
  # DELETE /chats/:access_token
  def destroy
    
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
