class Api::V1::NewsArticlesController < Api::V1::ApiController
  
  # GET /api/v1/news_articles/:id
  def show
    article = NewsAtricle.find(params[:id])
    article_json = ArticleSerializer.new(article).as_json
    render json: { article: article_json }, status: :ok
  end
end
