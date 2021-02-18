class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  
  # GET /home
  def index
    @home = {}
    
    # News Categories
    @home[:news_categories] = NewsCategory.all
    
    # Breaking News
    @home[:breaking_news_title] = BreakingNews.find_by(is_active: true)&.title
    
    # Trends
    @home[:trends] = []
    NewsArticle.left_joins(:lits).group(:id).order('COUNT(lits.id) DESC').limit(6).each do |trend|
      @home[:trends] << { url: trend.url, title: trend.title, img_url: trend.img_url }
    end
    
    
    if current_user && current_user.is_national_news? && params[:is_national]
      @home[:news_articles] = NewsArticle.where(country: current_user.country).order(published_at: :desc).page(params[:page]).per(16)
      @home[:is_national] = true
    else
      @home[:news_articles] = NewsArticle.order(published_at: :desc).page(params[:page]).per(16)
      @home[:is_national] = false
    end
  end
end
