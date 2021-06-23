class Api::V1::HomeController < Api::V1::ApiController
  skip_before_action :authenticate, only: [:news, :breaking_news, :trends]
  before_action :authenticate, only: [:news], if: :is_device_token?
  
  # GET /api/v1/home/news
  def news
    news_category = NewsCategory.find_by(title: 'general')
    
    # Get Country
    country = current_user&.country || Country.find_by(code: params[:location_code]) || Country.find_by(code: 'US')
    
    # Get News
    if params[:is_national]
      news = NewsArticle.joins(:news_categories).where(news_articles: { country: country }, news_categories: { id: news_category.id }).order(published_at: :desc).page(params[:page]).per(30)
    else
      if current_user
        languages = Language.where(id: current_user.languages.ids).or(Language.where(id: country.languages.ids)).uniq
      else
        languages = Language.where(id: country.languages.ids)
      end
      news = NewsArticle.joins(:news_categories).where.not(news_articles: { country: country }).where(news_articles: { detected_language: languages.pluck(:code) }, news_categories: { id: news_category.id }).order(published_at: :desc).page(params[:page]).per(30)
    end
    
    news = NewsArticle.joins(:news_categories).where(news_articles: { country: Country.find_by(code: 'US')}, news_categories: { id: news_category.id } ).page(params[:page]).per(30) if news.blank?
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
