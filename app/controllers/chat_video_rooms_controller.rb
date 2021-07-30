class ChatVideoRoomsController < ApplicationController
  layout 'twilio'
  before_action :get_chat, only: [:new, :complete, :update_participants_counter]
  before_action :get_chat_video_room, only: [:new]
  
  # GET /chats/:chat_access_token/chat_video_rooms
  def new
    if @chat_video_room.blank?
      @chat_video_room = ChatVideoRoom.create(chat: @chat)
      @chat_video_room_user_token = Tasks::TwilioTask.generate_access_token_for_user(current_user.username, @chat_video_room.sid)
    elsif @chat_video_room.present? && @chat_video_room.participants.count < 50
      @chat_video_room_user_token = Tasks::TwilioTask.generate_access_token_for_user(current_user.username, @chat_video_room.sid)
    else
      @chat_video_room_user_token = nil
    end
  end
  
  # PUT /chats/:chat_access_token/chat_video_rooms/complete
  def complete
    chat_video_room = @chat.chat_video_rooms.find_by(name: params[:chat_video_room_name], status: 'in-progress')
    unless chat_video_room
      render json: { errors: ['Record not found.']}, status: :ok
      return
    end
    
    if chat_video_room.participants.count > 0
      render json: { success: true }, status: :ok
      return
    end
    
    completed_room_name = Tasks::TwilioTask.complete_room(chat_video_room.sid)
    chat_video_room.status = 'completed'
    
    if completed_room_name.present? && completed_room_name == chat_video_room.name && chat_video_room.save
      render json: { success: true }, status: :ok
    else
      render json: { errors: ['Room can not be completed.'] }, status: :unprocessable_entity
    end
  end
  
  # PUT /chats/:chat_access_token/chat_video_rooms/update_participants_counter
  def update_participants_counter
    chat_video_room = @chat.chat_video_rooms.find_by(name: params[:chat_video_room_name], status: 'in-progress')
    unless chat_video_room
      render json: { errors: ['Record not found.']}, status: :ok
      return
    end
    
    chat_video_room.participants_count = params[:participants_count]
    if chat_video_room.save
      render json: { success: true }, status: :ok
    else
      render json: { errors: chat_video_room.errors.full_messages }, status: :unprocessable_entity
    end
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
