class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  
  # GET /home
  def index
    @home = {}
    @home[:breaking_news_title] = BreakingNews.find_by(is_active: true)&.title
    @home[:news_categories] = NewsCategory.all
  end
end
