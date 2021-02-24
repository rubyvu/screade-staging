class Api::V1::NewsArticlesController < Api::V1::ApiController
  before_action :get_article, only: [:lit, :show, :view, :unlit]
  
  # GET /api/v1/news_articles/:id
  def show
    news_article_json = NewsArticleSerializer.new(@news_article, current_user: current_user).as_json
    render json: { news_article: news_article_json }, status: :ok
  end
  
  # POST /api/v1/news_articles/:id/lit
  def lit
    lit = Lit.new(source: @news_article, user: current_user)
    if lit.save
      news_article_json = NewsArticleSerializer.new(@news_article, current_user: current_user).as_json
      render json: { news_article: news_article_json }, status: :ok
    else
      render json: { errors: lit.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # POST /api/v1/news_articles/:id/view
  def view
    view = View.new(source: @news_article, user: current_user)
    if view.save
      render json: { success: true }, status: :ok
    else
      render json: { success: false }, status: :ok
    end
  end
  
  # DELETE /api/v1/news_articles/:id/unlit
  def unlit
    lit = Lit.find_by!(source: @news_article, user: current_user)
    lit.destroy
    news_article_json = NewsArticleSerializer.new(@news_article, current_user: current_user).as_json
    render json: { news_article: news_article_json }, status: :ok
  end
  
  private
    def get_article
      @news_article = NewsArticle.find(params[:id])
    end
end
