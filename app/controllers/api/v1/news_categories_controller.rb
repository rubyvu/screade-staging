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
    
    # Get Country
    country = current_user&.country || Country.find_by(code: params[:location_code]) || Country.find_by(code: 'US')
    
    # Get Languages
    current_user ? languages = current_user.languages + country.languages : languages = country.languages
    
    if params[:is_national]
      # Get News Sources
      news_source = NewsSource.where(language: languages, country: country)
      
      news = NewsArticle.joins(:news_categories)
       .where(news_articles: { country: country }, news_categories: { id: news_category.id })
       .or(NewsArticle.joins(:news_categories).where(news_articles: { news_source: news_source }, news_categories: { id: news_category.id }))
       .order(published_at: :desc).page(params[:page]).per(30)
    else
      # Get News Sources
      news_source = NewsSource.where(language: languages).where.not(country: country)
      
      # Set Default News Sources if default World News is empty
      news_source = NewsSource.joins(:language).where(languages: { code: 'EN' }).where.not(news_sources: { country: country }) if news_source.blank?
      
      news = NewsArticle.joins(:news_categories).where(news_articles: { news_source: news_source }, news_categories: { id: news_category.id })
        .order(published_at: :desc).page(params[:page]).per(30)
    end
    
    news_json = ActiveModel::Serializer::CollectionSerializer.new(news, serializer: NewsArticleSerializer, current_user: current_user).as_json
    render json: { news: news_json }, status: :ok
  end
end
