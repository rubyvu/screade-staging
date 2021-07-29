class StreamsController < ApplicationController
  
  # GET /streams
  def index
    @streams = Stream.where(user: current_user).order(updated_at: :desc).page(params[:page]).per(30)
  end
  
  # GET /streams/:id
  def show
    @stream = Stream.find_by(id: params[:id])
    @new_comment = StreamComment.new(stream: @stream, user: current_user)
    @stream_comments = @stream.stream_comments
  end
end
