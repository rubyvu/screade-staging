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
    
    # Get Country
    country = current_user&.country || Country.find_by(code: current_location) || Country.find_by(code: 'US')
    
    # Get News
    if @category[:is_national]
      @category[:news_articles] = NewsArticle.joins(:news_categories).where(news_articles: { country: country }, news_categories: { id: news_category.id }).order(published_at: :desc).page(params[:page]).per(16)
    else
      if current_user
        languages = Language.where(id: current_user.languages.ids).or(Language.where(id: country.languages.ids)).uniq
      else
        languages = Language.where(id: country.languages.ids)
      end
      @category[:news_articles] = NewsArticle.joins(:news_categories).where.not(news_articles: { country: country }).where(news_articles: { detected_language: languages.pluck(:code) }, news_categories: { id: news_category.id }).order(published_at: :desc).page(params[:page]).per(16)
    end
    @category[:news_articles] = NewsArticle.joins(:news_categories).where(news_articles: { country: Country.find_by(code: 'US')}, news_categories: { id: news_category.id } ).page(params[:page]).per(16) if @category[:news_articles].blank?
  end
end
