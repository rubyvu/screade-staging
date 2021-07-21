class Api::V1::ChatAudioRoomsController < Api::V1::ApiController
  before_action :get_chat, only: [:create]
  before_action :get_chat_audio_room, only: [:create]
  
  
  # POST /chats/:chat_access_token/chat_audio_rooms
  def create
    @chat_audio_room = ChatAudioRoom.create(chat: @chat) if @chat_audio_room.blank?
    
    if @chat_audio_room.present? && @chat_audio_room.participants.count >= 50
      render json: { errors: ['Maximum 50 participants per room.'] }, status: :unprocessable_entity
      return
    end
    
    # Generate Twilio user token
    chat_audio_room_user_token = Tasks::TwilioTask.generate_access_token_for_user(current_user.username, @chat_audio_room.sid)
    unless chat_audio_room_user_token
      render json: { errors: ['Twilio user token can not be generated, try again later.'] }, status: :unprocessable_entity
      return
    end
    
    chat_audio_room_json = ChatAudioRoomSerializer.new(@chat_audio_room).as_json
    render json: { chat_audio_room: chat_audio_room_json, chat_audio_room_user_token: chat_audio_room_user_token }, status: :ok
  end
  
  private
    def get_chat
      @chat = Chat.find_by!(access_token: params[:chat_access_token])
    end
    
    def get_chat_audio_room
      @chat_audio_room = @chat.chat_audio_rooms.find_by(status: 'in-progress')
      return nil if @chat_audio_room.blank?
      
      # Check that audio room status is 'in-progress'
      current_rooms = Tasks::TwilioTask.retrieve_list_of_rooms(@chat_audio_room.name, 'in-progress')
      if current_rooms.include?(@chat_audio_room.sid)
        @chat_audio_room
      else
        @chat_audio_room.update_columns(status: 'completed')
        @chat_audio_room = nil
      end
    end
end
