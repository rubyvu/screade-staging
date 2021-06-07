class SearchesController < ApplicationController
  
  # GET /searches
  def index
    search_input = params[:search_input]&.downcase
    
    # Search queries
    users = User.search(search_input, limit: 5, execute: false)
    news_articles = NewsArticle.search(search_input, where: { detected_language: current_user.country.languages.pluck(:code) + current_user.languages.pluck(:code), created_at: { gt: 7.days.ago } }, limit: 5, execute: false)
    posts = Post.search(search_input, limit: 5, execute: false)
    news_category = NewsCategory.search(search_input, limit: 5, execute: false)
    topic = Topic.search(search_input, limit: 5, where: {is_approved: true}, execute: false)
    
    # Search request
    users_top, news_articles_top, posts_top, news_category_top, topic_top = Searchkick.multi_search([users, news_articles, posts, news_category, topic])
    groups_top = (news_category_top.to_a + topic_top.to_a)
    @search_result = {
      search_input: search_input,
      users_top: users_top,
      news_articles_top: news_articles_top,
      posts_top: posts_top,
      groups_top: groups_top,
      is_results: users_top.present? || news_articles_top.present? || posts_top.present? || groups_top.present?
    }
  end
end
