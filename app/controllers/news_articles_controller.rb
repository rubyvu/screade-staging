class NewsArticlesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:comments]
  before_action :get_article, only: [:comments, :create_comment, :lit, :search, :view, :unlit]
  
  # POST /news_articles/:id/lit
  def lit
    lit = Lit.new(source: @news_article, user: current_user)
    if lit.save
      render json: { success: true }, status: :ok
    else
      render json: { success: false }, status: :ok
    end
  end
  
  # POST /news_articles/:id/view
  def view
    view = View.new(source: @news_article, user: current_user)
    if view.save
      render json: { success: true }, status: :ok
    else
      render json: { success: false }, status: :ok
    end
  end
  
  # DELETE /news_articles/:id/unlit
  def unlit
    lit = Lit.find_by!(source: @news_article, user: current_user)
    lit.destroy
    render json: { success: true }, status: :ok
  end
  
  # GET /news_articles/:id/comments
  def comments
    @new_comment = Comment.new(source_type: 'NewsArticle')
    @comments = Comment.where(source: @news_article, comment_id: nil).order(created_at: :desc)
  end
  
  # POST /news_articles/:id/create_comment
  def create_comment
    new_comment = Comment.new(comment_params)
    new_comment.source = @news_article
    new_comment.user = current_user
    new_comment.save
    if new_comment.comment.present?
      redirect_to news_article_comment_reply_comments_path(news_article_id: @news_article.id, comment_id: new_comment.comment.id)
    else
      redirect_to comments_news_article_path(@news_article)
    end
  end
  
  # GET /news_articles/:id/search
  def search
    @groups_for_search = Topic.where(is_approved: true).order(nesting_position: :asc, title: :asc)
    respond_to do |format|
      format.js { render 'search', layout: false }
    end
  end
  
  # POST /news_articles/:id/topic_subscription
  def topic_subscription
    news_article = NewsArticle.find(params[:id])
    topic = Topic.find_by!(id: news_article_subscription_params[:topic_id])
    
    if news_article.topics.include?(topic)
      render json: { errors: ['Topic already subscribed.'] }, status: :unprocessable_entity
      return
    end
    
    news_article.topics << topic
    render json: { success: true }, status: :ok
  end
  
  private
    def get_article
      @news_article = NewsArticle.find(params[:id])
    end
    
    def comment_params
      params.require(:comment).permit(:comment_id, :message)
    end
    
    def news_article_subscription_params
      params.require(:news_article_subscription).permit(:topic_id)
    end
end
