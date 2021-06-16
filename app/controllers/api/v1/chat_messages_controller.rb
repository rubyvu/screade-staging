class Api::V1::ChatsController < Api::V1::ApiController
  before_action :get_chat, only: [:index, :create]
  before_action :get_user_image, only: [:create]
  before_action :get_user_video, only: [:create]
  
  # GET /api/v1/chats/:chat_access_token/chat_messages
  def index
    chat_messages = @chat.chat_messages.order(created_at: :desc).order(created_at: :desc).page(params[:page]).per(30)
    chat_messages_json = ActiveModel::Serializer::CollectionSerializer.new(chat_messages, serializer: ChatMessageSerializer).as_json
    render json: { chat_messages: chat_messages_json }, status: :ok
  end
  
  # POST /api/v1/chats/:chat_access_token/chat_messages
  def create
    # Initialize new Chat
    chat_message = ChatMessage.new(chat_message_params)
    chat_message.chat = @chat
    chat_message.user = current_user
    
    chat_message.audio_record = @audio_record if @audio_record.present?
    chat_message.asset_source = @user_image if @user_image.present?
    chat_message.asset_source = @user_video if @user_video.present?
    
    if chat_message.save
      chat_message_json = ChatMessageSerializer.new(chat_message).as_json
      render json: { chat_message: chat_message_json }, status: :ok
    else
      render json: { errors: chat_message.error.full_messages }, status: :unprocessable_entity
    end
  end
  
  private
    def get_chat
      @chat = Chat.find_by!(access_token: params[:chat_access_token])
    end
    
    def chat_message_params
      strong_params = params.require(:chat_message).permit(:image_id, :text, :message_type, :video_id, :audio_record)
      strong_params.delete(:image_id)
      strong_params.delete(:video_id)
      strong_params
    end
    
    def get_user_image
      @user_image = current_user.user_images.find_by(id: params[:chat_message][:image_id])
    end
    
    def get_user_video
      @user_video = current_user.user_videos.find_by(id: params[:chat_message][:video_id])
    end
end
