class Api::V1::SearchesController < Api::V1::ApiController
  
  # GET /api/v1/searches
  def index
    search_input = params[:search_input]&.downcase
    if search_input.blank?
      render json: { errors: ['Search input should contain at least 2 symbols.'] }, status: :unprocessable_entity
      return
    end
    
    users = User.search(search_input, limit: 5, execute: false)
    news_articles = NewsArticle.search(search_input, limit: 5, execute: false)
    posts = Post.search(search_input, limit: 5, execute: false)
    groups = Searchkick.search(search_input, models: [NewsCategory, Topic], limit: 5, execute: false)
    
    Searchkick.multi_search([users, news_articles, posts, groups])
    
    # TODO: Serialize it
  end
end
