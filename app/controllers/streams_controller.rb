class StreamsController < ApplicationController
  
  # GET /streams
  def index
    @is_private_stream = params[:is_private] == 'true'
    if @is_private_stream
      # User finished streams
      @streams = Stream.where(owner: current_user, status: 'finished', is_private: true).page(params[:page]).per(30)
    else
      # All Streams from User subscription
      @streams = Stream.includes(:users).where( streams: { is_private: true }, users: { id: current_user.id } )
                      .or(Stream.where(is_private: false, group_type: 'Topic', group_id: current_user.subscribed_topics))
                      .or(Stream.where(is_private: false, group_type: 'NewsCategory', group_id: current_user.subscribed_news_categories))
                      .where('(streams.in_progress_started_at < ? AND streams.status = ?) OR streams.status = ?', 30.seconds.ago, 'in-progress', 'finished')
                      .where.not(owner: current_user)
                      .order(created_at: :desc).page(params[:page]).per(30)
    end
  end
  
  # GET /streams/:access_token
  def show
    @stream = Stream.find_by(access_token: params[:access_token])
    View.find_or_create_by!(source: @stream, user: current_user)
    
    @new_comment = StreamComment.new(stream: @stream, user: current_user)
    @stream_comments = @stream.stream_comments.order(created_at: :desc).limit(100)
  end
  
  # DELETE /streams/:access_token
  def destroy
    @stream = Stream.find_by(access_token: params[:access_token], owner: current_user)
    @stream.destroy
    redirect_to streams_path(is_private: true)
  end
end
