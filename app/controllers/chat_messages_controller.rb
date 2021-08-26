class ChatMessagesController < ApplicationController
  before_action :get_chat, only: [:create, :images, :videos]
  before_action :get_user_image, only: [:create]
  before_action :get_user_video, only: [:create]
  
  # GET /chats/:chat_access_token/chat_messages
  def index
    
  end
  
  # POST /chats/:chat_access_token/chat_messages
  def create
    # Initialize new Chat
    @chat_message = ChatMessage.new(chat_message_params)
    @chat_message.chat = @chat
    @chat_message.user = current_user
    
    @chat_message.asset_source = @user_image if @user_image.present?
    @chat_message.asset_source = @user_video if @user_video.present?
    
    if @chat_message.save
      render json: { success: true }, callback: params[:callback], status: :ok
    else
      render json: { success: false }, callback: params[:callback], status: :unprocessable_entity
    end
  end
  
  # GET /chats/:chat_access_token/chat_messages/images
  def images
    @chat_images = current_user.user_images
    
    respond_to do |format|
      format.js { render 'images', layout: false }
    end
  end
  
  # GET /chats/:chat_access_token/chat_messages/videos
  def videos
    @chat_videos = current_user.user_videos
    
    respond_to do |format|
      format.js { render 'videos', layout: false }
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
