class Api::V1::NewsArticleCommentsController < Api::V1::ApiController
  skip_before_action :authenticate, only: [:index]
  before_action :get_article
  
  # GET /api/v1/news_articles/:news_article_id/news_article_comments
  def index
    comments_jons = ActiveModel::Serializer::CollectionSerializer.new(@news_article.comments.order(created_at: :desc).page(params[:page]).per(30), serializer: CommentSerializer, current_user: current_user).as_json
    render json: { comments: comments_jons }, status: :ok
  end
  
  # POST /api/v1/news_articles/:news_article_id/news_article_comments
  def create
    comment = Comment.new(comment_params)
    comment.source = @news_article
    comment.user = current_user
    if comment.save
      comment_jons = CommentSerializer.new(comment, current_user: current_user).as_json
      render json: { comment: comment_jons }, status: :ok
    else
      render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  private
    def get_article
      @news_article = NewsArticle.find(params[:news_article_id])
    end
    
    def comment_params
      params.require(:comment).permit(:message)
    end
end
