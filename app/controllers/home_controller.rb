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
    
    # News articles
    @home[:is_national] = params[:is_national].blank? || params[:is_national].to_s.downcase == "true"
    ## Get Country from User or by IP
    current_country = current_user&.country || Country.find_by(code: current_location)
    
    if @home[:is_national] && current_country
        @home[:news_articles] = NewsArticle.where(country: current_country).order(published_at: :desc).page(params[:page]).per(16)
    elsif current_country
        @home[:news_articles] = NewsArticle.joins(:news_source).where(news_sources: { language: current_country.languages }).order(published_at: :desc).page(params[:page]).per(16)
    else
      @home[:news_articles] = NewsArticle.order(published_at: :desc).page(params[:page]).per(16)
    end
  end
end
