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
    
    users_top, news_articles_top, posts_top, groups_top = Searchkick.multi_search([users, news_articles, posts, groups])
    
    users_top_json = ActiveModel::Serializer::CollectionSerializer.new(users_top.to_a, serializer: UserProfileSerializer).as_json
    news_articles_top_json = ActiveModel::Serializer::CollectionSerializer.new(news_articles_top.to_a, serializer: NewsArticleSerializer).as_json
    posts_top_json = ActiveModel::Serializer::CollectionSerializer.new(posts_top.to_a, serializer: PostSerializer).as_json
    groups_top_json = ActiveModel::Serializer::CollectionSerializer.new(groups_top.to_a, serializer: GroupSerializer).as_json
    
    render json: { users: users_top_json, news_articles: news_articles_top_json, posts: posts_top_json, groups: groups_top_json }, status: :ok
  end
end
