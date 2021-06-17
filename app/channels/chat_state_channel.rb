class ChatStateChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_state_channel"
  end
  
  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
