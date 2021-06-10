class ChatMessagesController < ApplicationController
  before_action :get_chat, only: [:create]
  
  # GET /chats/:chat_access_token/chat_messages
  def index
    
  end
  
  # POST /chats/:access_token/chat_messages
  def create
    # Initialize new Chat
    @chat_message = ChatMessage.new(chat_message_params)
    @chat_message.chat = @chat
    @chat_message.user = current_user
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
  
  private
    def get_chat
      @chat = Chat.find_by!(access_token: params[:chat_access_token])
    end
    
    def chat_message_params
      params.require(:chat_message).permit(:text, :message_type)
    end
    
    def render_message(chat_message)
      render partial: 'chat_messages/message', locals: { chat_message: chat_message }
    end
end
