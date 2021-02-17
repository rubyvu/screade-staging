class Api::V1::HomeController < Api::V1::ApiController
  
  # GET /api/v1/home/news
  def news
    if params[:is_national]
      news = ArticleNews.where().order(published_at: :desc).page(params[:page]).per(30)
    else
      news = ArticleNews.where().order(published_at: :desc).page(params[:page]).per(30)
    end
      
    news_json = ActiveModel::Serializer::CollectionSerializer.new(news, serializer: NewsArticleSerializer, current_user: current_user).as_json
    render json: { news: news_json }, status: :ok
  end
  
  # GET /api/v1/home/breaking_news
  def breaking_news
    breaking_news = BreakingNews.find_by(active: true)
    if breaking_news
      breaking_news_json = BreakingNewsSerializer.new(breaking_news).as_json
    else
      breaking_news_json = nil
    end
    
    render json: { breaking_news: breaking_news_json }, status: :ok
  end
  
  # GET /api/v1/home/trends
  def trends
    # TODO: Add calculation for Trends
    trends = ArticleNews.order(published_at: :desc).limit(6)
    trends_json = ActiveModel::Serializer::CollectionSerializer.new(trends, serializer: TrendSerializer).as_json
    render json: { trends: trends_json }, status: :ok
  end
end
