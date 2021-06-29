class Api::V1::NewsCategoriesController < Api::V1::ApiController
  skip_before_action :authenticate, only: [:news]
  before_action :authenticate, only: [:news], if: :is_device_token?
  
  # GET /api/v1/news_categories/
  def index
    news_categories = NewsCategory.where.not(title: 'general')
    news_categories_json = ActiveModel::Serializer::CollectionSerializer.new(news_categories, serializer: NewsCategorySerializer).as_json
    render json: { news_categories: news_categories_json }, status: :ok
  end
  
  # GET /api/v1/news_categories/:id/news
  def news
    news_category = NewsCategory.find(params[:id])
    
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
end
