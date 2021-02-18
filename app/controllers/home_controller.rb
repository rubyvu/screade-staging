class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  
  # GET /home
  def index
    @home = {}
    
    # Breaking News
    @home[:breaking_news_title] = BreakingNews.find_by(is_active: true)&.title
    
    # Trends
    @home[:trends] = []
    NewsArticle.left_joins(:lits).group(:id).order('COUNT(lits.id) DESC').limit(6).each do |trend|
      @home[:trends] << { url: trend.url, title: trend.title, img_url: trend.img_url }
    end
    
    # News
    @home[:news_categories] = NewsCategory.all
  end
end
