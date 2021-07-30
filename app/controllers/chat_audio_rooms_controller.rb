class ChatAudioRoomsController < ApplicationController
  layout 'twilio'
  before_action :get_chat, only: [:new, :complete, :update_participants_counter]
  before_action :get_chat_audio_room, only: [:new]
  
  # GET /chats/:chat_access_token/chat_audio_rooms
  def new
    if @chat_audio_room.blank?
      @chat_audio_room = ChatAudioRoom.create(chat: @chat)
      @chat_audio_room_user_token = Tasks::TwilioTask.generate_access_token_for_user(current_user.username, @chat_audio_room.sid)
    elsif @chat_audio_room.present? && @chat_audio_room.participants.count < 50
      @chat_audio_room_user_token = Tasks::TwilioTask.generate_access_token_for_user(current_user.username, @chat_audio_room.sid)
    else
      @chat_audio_room_user_token = nil
    end
  end
  
  # PUT /chats/:chat_access_token/chat_audio_rooms/complete
  def complete
    chat_audio_room = @chat.chat_audio_rooms.find_by(name: params[:chat_audio_room_name], status: 'in-progress')
    unless chat_audio_room
      render json: { errors: ['Record not found.']}, status: :ok
      return
    end
    
    if chat_audio_room.participants.count > 0
      render json: { success: true }, status: :ok
      return
    end
    
    completed_room_name = Tasks::TwilioTask.complete_room(chat_audio_room.sid)
    chat_audio_room.status = 'completed'
    
    if completed_room_name.present? && completed_room_name == chat_audio_room.name && chat_audio_room.save
      render json: { success: true }, status: :ok
    else
      render json: { errors: ['Room can not be completed.'] }, status: :unprocessable_entity
    end
  end
  
  # PUT /chats/:chat_access_token/chat_audio_rooms/update_participants_counter
  def update_participants_counter
    chat_audio_room = @chat.chat_audio_rooms.find_by(name: params[:chat_audio_room_name], status: 'in-progress')
    unless chat_audio_room
      render json: { errors: ['Record not found.']}, status: :ok
      return
    end
    
    chat_audio_room.participants_count = params[:participants_count]
    if chat_audio_room.save
      render json: { success: true }, status: :ok
    else
      render json: { errors: chat_audio_room.errors.full_messages }, status: :unprocessable_entity
    end
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
