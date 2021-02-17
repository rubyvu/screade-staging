class Api::V1::NewsArticlesController < Api::V1::ApiController
  before_action :get_article, only: [:comment, :lit, :show, :view, :unlit, :unview]
  
  # GET /api/v1/news_articles/:id
  def show
    news_article_json = ArticleSerializer.new(@news_article).as_json
    render json: { news_article: news_article_json }, status: :ok
  end
  
  # POST /api/v1/news_articles/:id/lit
  def lit
    lit = Lit.new(source: @news_article, user: current_user)
    if lit.save
      render json: { success: true }, status: :ok
    else
      render json: { success: false }, status: :ok
    end
  end
  
  # POST /api/v1/news_articles/:id/comment
  def comment
    comment = Comment.new(comment_params)
    comment.source = @news_article
    comment.user = current_user
    if comment.save
      comment_jons = CommentSerializer.new(current_user).as_json
      render json: { comment: comment_jons }, status: :ok
    else
      render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # POST /api/v1/news_articles/:id/view
  def view
    view = View.new(source: @news_article, user: current_user)
    if view.save
      render json: { success: true }, status: :ok
    else
      render json: { success: false }, status: :ok
    end
  end
  
  # DELETE /api/v1/news_articles/:id/unlit
  def unlit
    lit = Lit.find_by!(source: @news_article, user: current_user)
    lit.destroy
    render json: { success: true }, status: :ok
  end
  
  # DELETE /api/v1/news_articles/:id/unview
  def unview
    view = View.find_by!(source: @news_article, user: current_user)
    view.destroy
    render json: { success: true }, status: :ok
  end
  
  private
    def get_article
      @news_article = NewsArticle.find(params[:id])
    end
    
    def comment_params
      params.require(:comment).permit(:message)
    end
end
