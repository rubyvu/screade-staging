class DashboardController < ApplicationController
  # GET /dashboard
  def index
    @news_categories = NewsCategory.all
  end
end
