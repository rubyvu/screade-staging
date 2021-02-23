class Api::V1::HomeController < Api::V1::ApiController
  skip_before_action :authenticate, only: [:news, :breaking_news, :trends]
  
  # GET /api/v1/home/news
  def news
    authenticate if is_device_token?
    
    if current_user && current_user.is_national_news? && params[:is_national]
      news = NewsArticle.where(country: current_user.country).order(published_at: :desc).page(params[:page]).per(30)
    else
      news = NewsArticle.order(published_at: :desc).page(params[:page]).per(30)
    end
      
    news_json = ActiveModel::Serializer::CollectionSerializer.new(news, serializer: NewsArticleSerializer, current_user: current_user).as_json
    render json: { news: news_json }, status: :ok
  end
  
  # GET /api/v1/home/breaking_news
  def breaking_news
    breaking_news = BreakingNews.find_by(is_active: true)
    if breaking_news
      breaking_news_json = BreakingNewsSerializer.new(breaking_news).as_json
    else
      breaking_news_json = nil
    end
    
    render json: { breaking_news: breaking_news_json }, status: :ok
  end
  
  # GET /api/v1/home/trends
  def trends
    trends = NewsArticle.left_joins(:lits).group(:id).order('COUNT(lits.id) DESC').limit(6)
    trends_json = ActiveModel::Serializer::CollectionSerializer.new(trends, serializer: TrendSerializer).as_json
    render json: { trends: trends_json }, status: :ok
  end
end
