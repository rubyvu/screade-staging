class Api::V1::HomeController < Api::V1::ApiController
  skip_before_action :authenticate, only: [:news, :breaking_news, :trends]
  before_action :authenticate, only: [:news], if: :is_device_token?
  
  # GET /api/v1/home/news
  def news
    default_language = Language.find_by(code: 'EN')
    default_country = Country.find_by(code: params[:location_code])
    
    if params[:is_national]
      news_articles = current_user&.country&.news_articles
      news_articles = default_country&.news_articles if news_articles.blank?
      news_articles = NewsArticle.where(news_source: default_language.news_sources) if news_articles.blank?
    else
      news_articles = NewsArticle.joins(:news_source).where(news_sources: { language: current_user&.languages })
      news_articles = NewsArticle.joins(:news_source).where(news_sources: { language: current_user&.country&.languages }) if news_articles.blank?
      news_articles = NewsArticle.joins(:news_source).where(news_sources: { language: default_country&.languages }) if news_articles.blank?
      news_articles = NewsArticle.all if news_articles.blank?
    end
    
    news = news_articles.order(published_at: :desc).page(params[:page]).per(30)
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
