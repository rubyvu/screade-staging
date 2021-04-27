class Api::V1::NewsArticlesController < Api::V1::ApiController
  skip_before_action :authenticate, only: [:show]
  before_action :authenticate, only: [:show, :lit, :view, :unlit], if: :is_device_token?
  before_action :get_article, only: [:groups, :lit, :show, :view, :unlit]
  
  # GET /api/v1/news_articles/:id
  def show
    news_article_json = NewsArticleSerializer.new(@news_article, current_user: current_user).as_json
    render json: { news_article: news_article_json }, status: :ok
  end
  
  # POST /api/v1/news_articles/:id/lit
  def lit
    lit = Lit.new(source: @news_article, user: current_user)
    if lit.save
      news_article_json = NewsArticleSerializer.new(@news_article, current_user: current_user).as_json
      render json: { news_article: news_article_json }, status: :ok
    else
      render json: { errors: lit.errors.full_messages }, status: :unprocessable_entity
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
    news_article_json = NewsArticleSerializer.new(@news_article, current_user: current_user).as_json
    render json: { news_article: news_article_json }, status: :ok
  end
  
  # GET /api/v1/news_articles/:id/groups
  def groups
    groups_json = ActiveModel::Serializer::CollectionSerializer.new(NewsCategory.all + Topic.where(is_approved: true), serializer: GroupSerializer, current_user: current_user, news_article: @news_article).as_json
    render json: { groups: groups_json }, status: :ok
  end
  
  # POST /api/v1/news_articles/:id/topic_subscription
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
    
    def news_article_subscription_params
      params.require(:news_article_subscription).permit(:topic_id)
    end
end
