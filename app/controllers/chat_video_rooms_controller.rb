class ChatVideoRoomsController < ApplicationController
  before_action :get_chat, only: [:new, :participant_token]
  before_action :get_chat_video_room, only: [:new, :participant_token]
  
  # GET /chats/:chat_access_token/chat_video_rooms
  def new
    # TODO: error when Chat does not created
    @chat_video_room = ChatVideoRoom.create(chat: @chat) unless @chat_video_room
  end
  
  # GET /chats/:chat_access_token/chat_video_rooms/participant_toke
  def participant_token
    # token, name
    user_token = Tasks::TwilioTask.generate_access_token_for_user(current_user.username)
    # TODO: get error when token nil
    
    render json: { user_token: user_token, room_name: @chat_video_room.name }, status: :ok
  end
  
  private
    def get_chat
      @chat = Chat.find_by!(access_token: params[:chat_access_token])
    end
    
    def get_chat_video_room
      @chat_video_room = @chat.chat_video_rooms.find_by(status: 'in-progress')
    end
end
