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
    
    # Get Languages
    current_user ? languages = current_user.languages + country.languages : languages = country.languages
    
    if @category[:is_national]
      # Get News Sources
      news_source = NewsSource.where(language: languages, country: country)
      news_source = NewsSource.joins(:language).where(languages: { code: 'EN' }) if news_source.blank?
      
      @category[:news_articles] = NewsArticle.joins(:news_categories)
       .where(news_articles: { country: country }, news_categories: { id: news_category.id })
       .or(NewsArticle.joins(:news_categories).where(news_articles: { news_source: news_source }, news_categories: { id: news_category.id }))
       .order(published_at: :desc).page(params[:page]).per(16)
    else
      # Get News Sources
      news_source = NewsSource.where(language: languages).where.not(country: country)
      
      # Set Default News Sources if default World News is empty
      news_source = NewsSource.joins(:language).where(languages: { code: 'EN' }).where.not(news_sources: { country: country }) if news_source.blank?
      
      @category[:news_articles] = NewsArticle.joins(:news_categories).where(news_articles: { news_source: news_source }, news_categories: { id: news_category.id })
        .order(published_at: :desc).page(params[:page]).per(16)
    end
  end
end
