class Webhooks::TwilioController < ApplicationController
  skip_before_action :authenticate_user!
  protect_from_forgery unless: -> { request.content_type == 'application/x-www-form-urlencoded' }
  
  def status_callback
    status_event_callback = params['StatusCallbackEvent']
    room_status = params['RoomStatus']
    room_name = params['RoomName']
    
    room = nil
    if status_event_callback.blank? || room_status.blank? || room_name.blank?
      head :ok
      return
    end
    
    # Catch only needed type of requests
    if ['participant-connected', 'participant-disconnected', 'room-ended'].exclude?(status_event_callback)
      head :ok
      return
    end
    
    # Select Video or Audio room
    room_type = room_name.split('-')[0]
    if room_type == 'video'
      room = ChatVideoRoom.find_by(name: room_name, status: 'in-progress')
    elsif room_type == 'audio'
      room = nil
    end
    
    if room.blank?
      head :ok
      return
    end
    
    # Update data ONLY for Room with 'in-progress' status
    case status_event_callback
    when 'participant-connected'
      room.participants_count = room.participants.count
      room.save
    when 'participant-disconnected'
      room.participants_count = room.participants.count
      room.status = 'completed' if room.participants_count == 0
      room.save
    when 'room-ended'
      room.status = 'completed'
      room.save
    end
    
    head :ok
  end
end
