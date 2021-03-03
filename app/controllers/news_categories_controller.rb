class NewsCategoriesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  
  # GET /news_categories/:id
  def show
    # News Categories
    news_category = NewsCategory.find(params[:id])
    @category = {}
    @category[:news_categories] = NewsCategory.all
    
    # News articles
    @category[:is_national] = params[:is_national].blank? || params[:is_national].to_s.downcase == "true"
    ## Get Country from User or by IP
    current_country = current_user&.country || Country.find_by(code: current_location)
    
    if @category[:is_national] && current_country
      @category[:news_articles] = NewsArticle.joins(:news_categories).where(news_articles: { country: current_country }, news_categories: { id: news_category.id }).order(published_at: :desc).page(params[:page]).per(16)
    elsif current_country
      @category[:news_articles] = NewsArticle.joins(:news_source, :news_categories).where(news_sources: { language: current_country.languages }, news_categories: { id: news_category.id }).order(published_at: :desc).page(params[:page]).per(16)
    else
      @category[:news_articles] = NewsArticle.joins(:news_categories).where(news_categories: { id: news_category.id }).order(published_at: :desc).page(params[:page]).per(16)
    end
  end
end
