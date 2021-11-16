class Api::V1::PostCommentsController < Api::V1::ApiController
  before_action :get_post, only: [:index, :create]
  
  # GET /api/v1/posts/:post_id/post_comments
  def index
    comments_json = ActiveModel::Serializer::CollectionSerializer.new(@post.comments.where(comment_id: nil).order(created_at: :desc).page(params[:page]).per(30), serializer: CommentSerializer, current_user: current_user).as_json
    render json: { comments: comments_json }, status: :ok
  end
  
  # POST /api/v1/posts/:post_id/post_comments
  def create
    comment = Comment.new(comment_params)
    comment.source = @post
    comment.user = current_user
    if comment.save
      comment_json = CommentSerializer.new(comment, current_user: current_user).as_json
      render json: { comment: comment_json }, status: :ok
    else
      render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  private
    def get_post
      @post = Post.find(params[:post_id])
    end
    
    def comment_params
      params.require(:comment).permit(:comment_id, :message)
    end
end
