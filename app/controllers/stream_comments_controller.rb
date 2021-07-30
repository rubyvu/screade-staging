class StreamCommentsController < ApplicationController
  
  # POST /streams/:stream_id/stream_comments
  def create
    stream = Stream.find(params[:stream_id])
    stream_comment = StreamComment.new(stream_comments_params)
    
    stream_comment.stream = stream
    stream_comment.user = current_user
    
    if stream_comment.save!
      render json: { success: true }, status: :ok
    else
      render json: { success: false }, status: :unprocessable_entity
    end
  end
  
  private
    def stream_comments_params
      params.require(:stream_comment).permit(:message)
    end
end
