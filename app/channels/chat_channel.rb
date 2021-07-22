class ChatChannel < ApplicationCable::Channel
  def subscribed
    # Create channel for each User in each Chat to know who has Chanel subscription(for ChatNotifications)
    stream_from "chat_#{params[:chat_access_token]}_#{current_user.username}_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
