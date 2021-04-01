class Api::V1::HomeController < Api::V1::ApiController
  skip_before_action :authenticate, only: [:news, :breaking_news, :trends]
  before_action :authenticate, only: [:news], if: :is_device_token?
  
  # GET /api/v1/home/news
  def news
    # Get Country
    country = current_user&.country || Country.find_by(code: params[:location_code]) || Country.find_by(code: 'US')
    
    # Get Languages
    current_user ? languages = current_user.languages + country.languages : languages = country.languages
    
    if params[:is_national]
      # Get News Sources
      news_source = NewsSource.where(language: languages, country: country)
      news = NewsArticle.where(country: country)
        .or(NewsArticle.where(news_source: news_source))
        .order(published_at: :desc).page(params[:page]).per(30)
      news = NewsArticle.where(country: Country.find_by(code: 'US')).page(params[:page]).per(16) if news.blank?
    else
      # Get News Sources
      news_source = NewsSource.where(language: languages).where.not(country: country)
      
      # Set Default News Sources if default World News is empty
      news_source = NewsSource.joins(:language).where(languages: { code: 'EN' }).where.not(news_sources: { country: country }) if news_source.blank?
      
      news = NewsArticle.where(news_source: news_source).order(published_at: :desc).page(params[:page]).per(30)
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
