class TwilioRoomStateChannel < ApplicationCable::Channel
  def subscribed
    stream_from "twilio_room_#{params[:chat_access_token]}_state_chanel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
