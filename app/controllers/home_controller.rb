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
    default_language = Language.find_by(code: 'EN')
    default_country = Country.find_by(code: current_location)
    
    if @home[:is_national]
      news_articles = current_user&.country&.news_articles
      news_articles = default_country&.news_articles if news_articles.blank?
      news_articles = NewsArticle.where(news_source: default_language.news_sources) if news_articles.blank?
    else
      news_articles = NewsArticle.joins(:news_source).where(news_sources: { language: current_user&.languages })
      news_articles = NewsArticle.joins(:news_source).where(news_sources: { language: current_user&.country&.languages }) if news_articles.blank?
      news_articles = NewsArticle.joins(:news_source).where(news_sources: { language: default_country&.languages }) if news_articles.blank?
      news_articles = NewsArticle.all if news_articles.blank?
    end
    
    @home[:news_articles] = news_articles.order(published_at: :desc).page(params[:page]).per(16)
  end
end
