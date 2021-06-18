class NewUserChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "new_#{current_user.username}_chat_channel"
  end
  
  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
