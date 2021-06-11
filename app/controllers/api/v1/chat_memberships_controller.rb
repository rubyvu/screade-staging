class Api::V1::ChatMembershipsController < Api::V1::ApiController
  before_action :get_chat, only: [:index]
  before_action :get_chat_membership, only: [:update, :destroy]
  
  # GET /api/v1/chats/:chat_access_token/chat_memberships
  def index
    chat_memberships_json = ActiveModel::Serializer::CollectionSerializer.new(@chat.chat_memberships.order(updated_at: :desc).page(params[:page]).per(30), serializer: ChatMembershipSerializer).as_json
    render json: { chat_memberships: chat_memberships_json }, status: :ok
  end
  
  # PUT/PATCH /api/v1/chat_memberships/:id
  def update
    current_user_membership = ChatMembership.find_by!(user: current_user, chat: @chat_membership.chat)
    
    if current_user_membership.role != 'owner'
      render json: { errors: ['Can be changed only by Owner.'] }, status: :unprocessable_entity
      return
    end
    
    if @chat_membership.update(memberships_params)
      chat_membership_json = ChatMembershipSerializer.new(@chat_membership).as_json
      render json: { chat_membership: chat_membership_json }, status: :ok
    else
      render json: { errors: @chat_membership.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # DELETE /api/v1/chat_memberships/:access_token
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
      params.require(:chat_membership).permit(:role)
    end
end
