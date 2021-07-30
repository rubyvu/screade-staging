class NewStreamCommentChannel < ApplicationCable::Channel
  def subscribed
    stream_from "new_stream_#{params[:stream_id]}_comment_channel"
  end
  
  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
