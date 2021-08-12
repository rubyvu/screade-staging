class StreamInfoChannel < ApplicationCable::Channel
  def subscribed
    stream_from "stream_info_#{params[:stream_access_token]}_channel"
  end
  
  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
