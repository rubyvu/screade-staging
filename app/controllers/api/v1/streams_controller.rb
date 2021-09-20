class Api::V1::StreamsController < Api::V1::ApiController
  before_action :get_stream, only: [:update, :complete, :destroy]
  
  # GET /api/v1/streams
  def index
    if params[:is_private]
      # User finished streams
      streams = Stream.where(owner: current_user, status: 'finished', is_private: true).page(params[:page]).per(30)
    else
      # All Streams from User subscription
      streams = Stream.includes(:users)
                      .where(streams: { is_private: true }, users: { id: current_user.id })
                      .or(Stream.where(is_private: false, group_type: 'Topic', group_id: current_user.subscribed_topics))
                      .or(Stream.where(is_private: false, group_type: 'NewsCategory', group_id: current_user.subscribed_news_categories))
                      .where('(streams.created_at < ? AND streams.status = ?) OR streams.status = ?', 30.seconds.ago, 'in-progress', 'finished')
                      .where.not(owner: current_user)
                      .order(created_at: :desc).page(params[:page]).per(30)
    end
    
    streams_json = ActiveModel::Serializer::CollectionSerializer.new(streams, serializer: StreamSerializer, current_user: current_user ).as_json
    render json: { streams: streams_json }, status: :ok
  end
  
  # GET /api/v1/streams/:access_token
  def show
    stream = Stream.find_by!(access_token: params[:access_token])
    if stream.is_private && (stream.owner != current_user && stream.users.exclude?(current_user))
      render json: { errors: ['Record not found.'] }, status: :not_found
      return
    end
    
    View.find_or_create_by(source: stream, user: current_user)
    stream_json = StreamSerializer.new(stream, current_user: current_user).as_json
    render json: { stream: stream_json }, status: :ok
  end
  
  # POST /api/v1/streams
  def create
    # API Client Init
    live_api = MuxRuby::LiveStreamsApi.new
    
    # Create the Live Stream
    create_asset_request = MuxRuby::CreateAssetRequest.new
    create_asset_request.playback_policy = [MuxRuby::PlaybackPolicy::PUBLIC]
    create_live_stream_request = MuxRuby::CreateLiveStreamRequest.new
    create_live_stream_request.new_asset_settings = create_asset_request
    create_live_stream_request.playback_policy = [MuxRuby::PlaybackPolicy::PUBLIC]
    mux_stream = live_api.create_live_stream(create_live_stream_request)
    
    stream = Stream.new(
      owner: current_user,
      title: stream_params[:title],
      is_private: stream_params[:is_private],
      mux_stream_id: mux_stream.data.id,
      mux_stream_key: mux_stream.data.stream_key,
      mux_playback_id: mux_stream.data.playback_ids.first.id
    )
    
    # Set params for publick/private Streams
    if stream.is_private
      stream.users << User.where(username: stream_params[:usernames])
    else
      group_type = stream_params[:group_type]
      group_id = stream_params[:group_id]
      
      if group_type == 'NewsCategory'
        stream.group = NewsCategory.find_by(id: group_id)
      elsif group_type == 'Topic'
        stream.group = Topic.find_by(id: group_id)
      end
    end
    
    if stream.save
      stream_json = StreamSerializer.new(stream, current_user: current_user).as_json
      render json: { stream: stream_json }, status: :ok
    else
      render json: { errors: stream.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # PUT/PATCH /api/v1/streams/:access_token
  def update
    if stream_update_params[:video].present? && @stream.status == 'completed'
      begin
        @stream.video.attach(stream_update_params[:video])
        @stream.status = 'finished'
      rescue
        render json: { errors: ['Can not attach Video.'] }, status: :unprocessable_entity
        return
      end
    end
    
    if @stream.update(stream_update_params.except(:video))
      stream_json = StreamSerializer.new(@stream, current_user: current_user).as_json
      render json: { stream: stream_json }, status: :ok
    else
      render json: { errors: @stream.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # PUT/PATCH /api/v1/streams/:access_token/complete
  def complete
    if @stream.update(status: 'completed')
      stream_json = StreamSerializer.new(@stream, current_user: current_user).as_json
      render json: { stream: stream_json }, status: :ok
    else
      render json: { errors: @stream.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # DELETE /api/v1/streams/:access_token
  def destroy
    @stream.destroy
    render json: { success: true }, status: :ok
  end
  
  private
    def get_stream
      @stream = Stream.find_by!(access_token: params[:access_token], owner: current_user)
    end
    
    def stream_params
      params.require(:stream).permit(:group_id, :group_type, :is_private, :title, usernames: [])
    end
    
    def stream_update_params
      params.require(:stream).permit(:image, :title, :video)
    end
end
