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
    default_language = Language.find_by(code: 'EN')
    default_country = Country.find_by(code: current_location)
    
    if @category[:is_national]
      news_articles = NewsArticle.joins(:news_categories).where(news_articles: { country: current_user&.country }, news_categories: { id: news_category.id })
      news_articles = NewsArticle.joins(:news_categories).where(news_articles: { country: default_country }, news_categories: { id: news_category.id }) if news_articles.blank?
      news_articles = NewsArticle.joins(:news_categories).where(news_articles: { news_source: default_language.news_sources }, news_categories: { id: news_category.id }) if news_articles.blank?
    else
      news_articles = NewsArticle.joins(:news_source, :news_categories).where(news_sources: { language: current_user&.languages }, news_categories: { id: news_category.id })
      news_articles = NewsArticle.joins(:news_source, :news_categories).where(news_sources: { language: current_user&.country&.languages }, news_categories: { id: news_category.id }) if news_articles.blank?
      news_articles = NewsArticle.joins(:news_source, :news_categories).where(news_sources: { language: default_country&.languages }, news_categories: { id: news_category.id }) if news_articles.blank?
      news_articles = NewsArticle.all if news_articles.blank?
    end
    
    @category[:news_articles] = news_articles.order(published_at: :desc).page(params[:page]).per(16)
  end
end
