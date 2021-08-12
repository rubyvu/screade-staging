class StreamsController < ApplicationController
  
  # GET /streams
  def index
    @is_private_stream = params[:is_private] == 'true'
    if @is_private_stream
      # User finished streams
      @streams = Stream.where(owner: current_user, status: 'finished', is_private: true).page(params[:page]).per(30)
    else
      # All Streams from User subscription
      @streams = Stream.joins(:users).where( streams: { is_private: true }, users: { id: current_user.id } )
                      .or(Stream.where(is_private: false, group_type: 'Topic', group_id: current_user.subscribed_topics))
                      .or(Stream.where(is_private: false, group_type: 'NewsCategory', group_id: current_user.subscribed_news_categories))
                      .where(status: ['in-progress', 'finished'])
                      .page(params[:page]).per(30)
    end
  end
  
  # GET /streams/:id
  def show
    @stream = Stream.find_by(id: params[:id])
    View.find_or_create_by!(source: @stream, user: current_user)
    
    @new_comment = StreamComment.new(stream: @stream, user: current_user)
    @stream_comments = @stream.stream_comments.order(created_at: :desc).limit(100)
  end
end
