class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :theme]

  ALLOWED_THEMES = ['light', 'dark', 'dark-1', 'dark-2', 'dark-3', 'dark-4', 'dark-5'].freeze

  # GET /home
  def index
    if params[:invitation_token]
      sign_out(current_user) if current_user
    end

    @home = {}

    # News Categories
    @home[:news_categories] = NewsCategory.where.not(title: 'general')

    # Breaking News
    @home[:breaking_news_post] = BreakingNews.get_breaking_news.post

    # Trends
    @home[:trends] = []
    (NewsArticle.order(lits_count: :desc).limit(6) + Stream.where(is_private: false, status: ['in-progress', 'finished']).order(lits_count: :desc).limit(6) + Post.order(lits_count: :desc)).sort_by { |trend| -trend.lits_count }.first(6).each do |trend|
      trend_params = {}
      case trend.class.name
      when 'NewsArticle'
        trend_params = { url: trend.url, title: trend.title, img_url: trend.img_url }
      when 'Stream'
        trend_params = { url: stream_path(trend.access_token), title: trend.title, img_url: trend.image.url }
      when 'Post'
        trend_params = { url: post_post_comments_path(post_id: trend.id), title: trend.title, img_url: trend.image.url }
      end

      @home[:trends] << trend_params if trend_params.present?
    end

    # News articles
    news_category = NewsCategory.find_by(title: 'general')

    # News articles
    @home[:is_national] = params[:is_national].blank? || params[:is_national].to_s.downcase == 'true'

    # Get Country
    country = current_user&.country || Country.find_by(code: current_location) || Country.find_by(code: 'US')

    # Get News
    if @home[:is_national]
      @home[:news_articles] = NewsArticle.joins(:news_categories)
                                         .includes([:liting_users, :commenting_users, :viewing_users])
                                         .where(news_articles: { country: country }, news_categories: { id: news_category.id })
                                         .order(published_at: :desc)
                                         .page(params[:page])
                                         .per(16)
    else
      if current_user
        languages = Language.where(id: current_user.languages.ids).or(Language.where(id: country.languages.ids)).uniq
      else
        languages = Language.where(id: country.languages.ids)
      end
      @home[:news_articles] = NewsArticle.joins(:news_categories)
                                         .includes([:liting_users, :commenting_users, :viewing_users])
                                         .where.not(news_articles: { country: country })
                                         .where(news_articles: { detected_language: languages.pluck(:code) }, news_categories: { id: news_category.id })
                                         .order(published_at: :desc)
                                         .page(params[:page])
                                         .per(16)
    end

    if @home[:news_articles].blank?
      @home[:news_articles] = NewsArticle.joins(:news_categories)
                                         .includes([:liting_users, :commenting_users, :viewing_users])
                                         .where(news_articles: { country: Country.find_by(code: 'US')}, news_categories: { id: news_category.id } )
                                         .order(published_at: :desc)
                                         .page(params[:page])
                                         .per(16)
    end
  end

  # PUT /home/theme
  def theme
    new_theme = params[:theme]

    if ALLOWED_THEMES.include?(new_theme)
      cookies[:theme] = new_theme
    end

    redirect_to(request.referrer || root_path)
  end
end
