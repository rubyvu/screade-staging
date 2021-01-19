class NewsCategoriesController < ApplicationController
  # GET /news_categories/:id
  def show
    @news_category = NewsCategory.find(params[:id])
  end
end
