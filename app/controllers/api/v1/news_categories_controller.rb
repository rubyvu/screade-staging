class Api::V1::NewsCategoriesController < Api::V1::ApiController
  skip_before_action :authenticate, only: [:index, :news_articles]
  
  # GET /api/v1/news_categories/
  def index
    news_categories = NewsCategory.all
    news_categories_json = ActiveModel::Serializer::CollectionSerializer.new(news_categories, serializer: NewsCategorySerializer).as_json
    render json: { news_categories: news_categories_json }, status: :ok
  end
  
  # GET /api/v1/news_categories/:id/news
  def news
    authenticate if is_device_token?
    
    news_category = NewsCategory.find(params[:id])
    if current_user && current_user.is_national_news? && params[:is_national]
      news = NewsArticle.joins(:news_categories).where(news_articles: { country: current_user.country }, news_categories: { id: news_category.id }).order(published_at: :desc).page(params[:page]).per(30)
    else
      if current_user&.is_world_news?
        news = NewsArticle.joins(:news_source, :news_categories).where(news_sources: { language: current_user.country.languages }, news_categories: { id: news_category.id }).order(published_at: :desc).page(params[:page]).per(30)
      else
        news = NewsArticle.joins(:news_categories).where(news_categories: { id: news_category.id }).page(params[:page]).per(30)
      end
    end
      
    news_json = ActiveModel::Serializer::CollectionSerializer.new(news, serializer: NewsArticleSerializer, current_user: current_user).as_json
    render json: { news: news_json }, status: :ok
  end
end
