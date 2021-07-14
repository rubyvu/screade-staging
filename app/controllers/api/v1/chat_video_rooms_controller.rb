class Api::V1::ChatVideoRoomsController < Api::V1::ApiController
  before_action :get_chat, only: [:create]
  before_action :get_chat_video_room, only: [:create]
  
  
  # POST /chats/:chat_access_token/chat_video_rooms
  def create
    @chat_video_room = ChatVideoRoom.create(chat: @chat) if @chat_video_room.blank?
    
    if @chat_video_room.present? && @chat_video_room.participants.count >= 50
      render json: { errors: ['Maximum 50 participants per room.'] }, status: :unprocessable_entity
      return
    end
    
    # Generate Twilio user token
    chat_video_room_user_token = Tasks::TwilioTask.generate_access_token_for_user(current_user.username, @chat_video_room.sid)
    chat_video_room_json = ChatVideoRoomSerializer.new(@chat_video_room).as_json
    render json: { chat_video_room: chat_video_room_json, chat_video_room_user_token: chat_video_room_user_token }, status: :ok
  end
  
  private
    def get_chat
      @chat = Chat.find_by!(access_token: params[:chat_access_token])
    end
    
    def get_chat_video_room
      @chat_video_room = @chat.chat_video_rooms.find_by(status: 'in-progress')
      return nil if @chat_video_room.blank?
      
      # Check that video room status is 'in-progress'
      current_rooms = Tasks::TwilioTask.retrieve_list_of_rooms(@chat_video_room.name, 'in-progress')
      if current_rooms.include?(@chat_video_room.sid)
        @chat_video_room
      else
        @chat_video_room.update_columns(status: 'completed')
        @chat_video_room = nil
      end
    end
end
