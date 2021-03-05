class Api::V1::NewsCategoriesController < Api::V1::ApiController
  skip_before_action :authenticate, only: [:news]
  before_action :authenticate, only: [:news], if: :is_device_token?
  
  # GET /api/v1/news_categories/
  def index
    news_categories = NewsCategory.all
    news_categories_json = ActiveModel::Serializer::CollectionSerializer.new(news_categories, serializer: NewsCategorySerializer).as_json
    render json: { news_categories: news_categories_json }, status: :ok
  end
  
  # GET /api/v1/news_categories/:id/news
  def news
    news_category = NewsCategory.find(params[:id])
    default_language = Language.find_by(code: 'EN')
    default_country = Country.find_by(code: params[:location_code])
    
    if params[:is_national]
      news_articles = NewsArticle.joins(:news_categories).where(news_articles: { country: current_user&.country }, news_categories: { id: news_category.id })
      news_articles = NewsArticle.joins(:news_categories).where(news_articles: { country: default_country }, news_categories: { id: news_category.id }) if news_articles.blank?
      news_articles = NewsArticle.joins(:news_categories).where(news_articles: { news_source: default_language.news_sources }, news_categories: { id: news_category.id }) if news_articles.blank?
    else
      news_articles = NewsArticle.joins(:news_source, :news_categories).where(news_sources: { language: current_user&.languages }, news_categories: { id: news_category.id })
      news_articles = NewsArticle.joins(:news_source, :news_categories).where(news_sources: { language: current_user&.country&.languages }, news_categories: { id: news_category.id }) if news_articles.blank?
      news_articles = NewsArticle.joins(:news_source, :news_categories).where(news_sources: { language: default_country&.languages }, news_categories: { id: news_category.id }) if news_articles.blank?
      news_articles = NewsArticle.all if news_articles.blank?
    end
    
    news = news_articles.order(published_at: :desc).page(params[:page]).per(30)
    news_json = ActiveModel::Serializer::CollectionSerializer.new(news, serializer: NewsArticleSerializer, current_user: current_user).as_json
    render json: { news: news_json }, status: :ok
  end
end
