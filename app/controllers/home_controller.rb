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
    
    # Get Country
    country = current_user&.country || Country.find_by(code: current_location) || Country.find_by(code: 'US')
    
    # Get Languages
    current_user ? languages = current_user.languages : languages = country.languages
    
    if @home[:is_national]
      # Get News Sources
      news_source = NewsSource.where(language: languages, country: country)
      @home[:news_articles] = NewsArticle.where(country: country)
        .or(NewsArticle.where(news_source: news_source))
        .order(published_at: :desc).page(params[:page]).per(16)
    else
      # Get News Sources
      news_source = NewsSource.where(language: languages).where.not(country: country)
      
      # Set Default News Sources if default World News is empty
      news_source = NewsSource.joins(:language).where(languages: { code: 'EN' }).where.not(news_sources: { country: country }) if news_source.blank?
      
      @home[:news_articles] = NewsArticle.where(news_source: news_source).order(published_at: :desc).page(params[:page]).per(16)
    end
  end
end
