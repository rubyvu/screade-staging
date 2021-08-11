class Api::V1::StreamCommentsController < Api::V1::ApiController
  before_action :get_stream, only: [:index, :create]
  
  # GET /api/v1/stream/:stream_access_token/stream_comments
  def index
    comments_json = ActiveModel::Serializer::CollectionSerializer.new(@stream.comments.order(created_at: :desc).page(params[:page]).per(30), serializer: StreamCommentSerializer, current_user: current_user).as_json
    render json: { stream_comments: comments_json }, status: :ok
  end
  
  # POST /api/v1/stream/:stream_access_token/stream_comments
  def create
    comment = StreamComment.new(stream_comment_params)
    comment.stream = @stream
    comment.user = current_user
    if comment.save
      comment_json = StreamCommentSerializer.new(comment, current_user: current_user).as_json
      render json: { stream_comment: comment_json }, status: :ok
    else
      render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  private
    def get_stream
      @stream = Stream.find(params[:stream_access_token])
    end
    
    def stream_comment_params
      params.require(:stream_comment).permit(:message)
    end
end
