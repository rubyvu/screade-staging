class Webhooks::TwilioController < ApplicationController
  skip_before_action :authenticate_user!
  protect_from_forgery unless: -> { request.content_type == 'application/x-www-form-urlencoded' }
  
  def status_callback
    room_status = params['RoomStatus']
    room_name = params['RoomName']
    compleate_status = 'completed'
    room = nil
    
    if room_status.blank? || room_name.blank? || room_status != compleate_status
      head :ok
      return
    end
    
    room_type = room_name.split('-')[0]
    if room_type == 'video'
      room = ChatVideoRoom.find_by(name: room_name, status: 'in-progress')
    elsif room_type == 'audio'
      room = nil
    end
    
    if room.blank? || room.status == compleate_status
      head :ok
      return
    end
    
    room.status = compleate_status
    room.save!
    head :ok
  end
end
