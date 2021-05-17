class SearchesController < ApplicationController
  
  # GET /searches
  def index
    search_input = params[:search_input]&.downcase
    
    users = User.search(search_input, limit: 5, execute: false)
    news_articles = NewsArticle.search(search_input, limit: 5, execute: false)
    posts = Post.search(search_input, limit: 5, execute: false)
    groups = Searchkick.search(search_input, models: [NewsCategory, Topic], limit: 5, execute: false)
    users_top, news_articles_top, posts_top, groups_top = Searchkick.multi_search([users, news_articles, posts, groups])
    
    @search_result = [
      users_top:  users_top,
      news_articles_top:  news_articles_top,
      posts_top:  posts_top,
      groups_top:  groups_top
    ]
  end
end
