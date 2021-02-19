class NewsArticlesController < ApplicationController
  before_action :get_article, only: [:lit, :view, :unlit]
  
  # POST /news_articles/:id/lit
  def lit
    lit = Lit.new(source: @news_article, user: current_user)
    if lit.save
      render json: { success: true }, status: :ok
    else
      render json: { success: false }, status: :ok
    end
  end
  
  # POST /news_articles/:id/view
  def view
    view = View.new(source: @news_article, user: current_user)
    if view.save
      render json: { success: true }, status: :ok
    else
      render json: { success: false }, status: :ok
    end
  end
  
  # DELETE /news_articles/:id/unlit
  def unlit
    lit = Lit.find_by!(source: @news_article, user: current_user)
    lit.destroy
    render json: { success: true }, status: :ok
  end
  
  private
    def get_article
      @news_article = NewsArticle.find_by(id: params[:id])
      # unless @news_article
      #   render json: { errors: ['Record not found.'] }, status: :not_found
      #   return
      # end
    end
end
