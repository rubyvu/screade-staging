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
    
    # Get Articles
    if @home[:is_national]
      @home[:news_articles] = NewsArticle.where(country: country).order(published_at: :desc).page(params[:page]).per(16)
    else
      if current_user
        languages = Language.where(id: current_user.languages.ids).or(Language.where(id: country.languages.ids)).uniq
      else
        languages = Language.where(id: country.languages.ids)
      end
      @home[:news_articles] = NewsArticle.where.not(country: country).where(detected_language: languages.pluck(:code)).order(published_at: :desc).page(params[:page]).per(16)
    end
    
    @home[:news_articles] = NewsArticle.where(country: Country.find_by(code: 'US')).page(params[:page]).per(16) if @home[:news_articles].blank?
  end
end
