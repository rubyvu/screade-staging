class Api::V1::ChatsController < Api::V1::ApiController
  before_action :get_chat, only: [:show, :update, :update_members]
  before_action :get_current_user_membership, only: [:show, :update, :update_members]
  
  # GET /api/v1/chats
  def index
    @chats = Chat.joins(:chat_memberships).where(chat_memberships: { user: current_user }).order(updated_at: :desc).page(params[:page]).per(30)
    chats_json = ActiveModel::Serializer::CollectionSerializer.new(@chats, serializer: ChatSerializer, current_user: current_user).as_json
    render json: { chats: chats_json }, status: :ok
  end
  
  # GET /api/v1/chats/:access_token
  def show
    # Clear unread message counter
    @current_user_membership.update_columns(unread_messages_count: 0)
    
    chat_json = ChatSerializer.new(@chat, current_user: current_user).as_json
    render json: { chat: chat_json }, status: :ok
  end
  
  # POST /api/v1/chats
  def create
    # Initialize new Chat
    chat = Chat.new(owner: current_user)
    
    # Initialize ChatMembership for Owner
    chat.chat_memberships.build(user: current_user)
    
    # Initialize ChatMembership for other Users
    User.where(username: memberships_params[:usernames]).each do |user|
      chat.chat_memberships.build(user: user)
    end
    
    if chat.save
      chat_json = ChatSerializer.new(chat, current_user: current_user).as_json
      render json: { chat: chat_json }, status: :ok
    else
      render json: { errors: chat.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # PUT/PATCH /api/v1/chats/:access_token
  def update
    if @chat.update(chat_params)
      chat_json = ChatSerializer.new(@chat, current_user: current_user).as_json
      render json: { chat: chat_json }, status: :ok
    else
      render json: { errors: @chat.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # PUT /api/v1/chats/:access_token/update_members
  def update_members
    new_chat_users = User.where(username: memberships_params[:usernames])
    
    # Add new ChatMembersips to Chat
    new_chat_users.each do |user|
      next if @chat.chat_memberships.exists?(user_id: user.id)
      ChatMembership.create(chat: @chat, user: user)
    end
    
    chat_json = ChatSerializer.new(@chat, current_user: current_user).as_json
    render json: { chat: chat_json }, status: :ok
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
