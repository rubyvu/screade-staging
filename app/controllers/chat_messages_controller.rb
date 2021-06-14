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
    
    @chat_message.audio_record = @audio_record if @audio_record.present?
    @chat_message.asset_source = @user_image if @user_image.present?
    @chat_message.asset_source = @user_video if @user_video.present?
    
    if @chat_message.save
      ActionCable.server.broadcast "chat_#{@chat.access_token}_channel", chat_message: render_message(@chat_message)
      
      head :ok
      # respond_to do |format|
      #   format.js { render 'create', layout: false }
      # end
    else
      #TODO :error here
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
    
    def render_message(chat_message)
      render partial: 'chat_messages/message', locals: { chat_message: chat_message }
    end
    
    def get_user_image
      @user_image = current_user.user_images.find_by(id: params[:chat_message][:image_id])
    end
    
    def get_user_video
      @user_video = current_user.user_videos.find_by(id: params[:chat_message][:video_id])
    end
end
