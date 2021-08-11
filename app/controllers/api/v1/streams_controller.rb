class Api::V1::StreamsController < Api::V1::ApiController
  before_action :get_stream, only: [:show, :update, :complete, :destroy]
  
  # GET /api/v1/streams
  def index
    if params[:is_private]
      # User finished streams
      streams = Stream.where(user: current_user, status: 'finished', is_private: true).page(params[:page]).per(30)
    else
      # All Streams from User subscription
      streams = Stream.joins(:users).where( streams: { is_private: true }, users: { id: current_user.id } )
                      .or(Stream.where(is_private: false, group_type: 'Topic', group_id: current_user.subscribed_topics))
                      .or(Stream.where(is_private: false, group_type: 'NewsCategory', group_id: current_user.subscribed_news_categories))
                      .where(status: ['in-progress', 'finished'])
                      .page(params[:page]).per(30)
    end
    
    streams_json = ActiveModel::Serializer::CollectionSerializer.new(streams, serializer: StreamSerializer).as_json
    render json: { streams: streams_json }, status: :ok
  end
  
  # GET /api/v1/streams/:access_token
  def show
    View.find_or_create_by(source: @stream, user: current_user)
    stream_json = StreamSerializer.new(@stream).as_json
    render json: { stream: stream_json }, status: :ok
  end
  
  # POST /api/v1/streams
  def create
    stream = Stream.new(user: current_user, title: stream_params[:title], is_private: stream_params[:is_private])
    
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
      stream_json = StreamSerializer.new(stream).as_json
      render json: { stream: stream_json }, status: :ok
    else
      render json: { errors: stream.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # PUT/PATCH /api/v1/streams/:access_token
  def update
    @stream.status == 'finished' if stream_update_params[:video].present? && @stream.status == 'completed'
    if @stream.update(stream_update_params)
      stream_json = StreamSerializer.new(@stream).as_json
      render json: { stream: stream_json }, status: :ok
    else
      render json: { errors: @stream.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # PUT/PATCH /api/v1/streams/:access_token/complete
  def complete
    if @stream.save(status: 'complete')
      stream_json = StreamSerializer.new(@stream).as_json
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
      @stream = Stream.find_by!(access_token: params[:access_token], user: current_user)
    end
    
    def stream_params
      params.require(:stream).permit(:group_id, :group_type, :is_private, :image, :title, :video, usernames: [])
    end
    
    def stream_update_params
      params.require(:stream).permit(:image, :title, :video)
    end
end
