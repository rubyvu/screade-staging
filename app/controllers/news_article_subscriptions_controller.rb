class NewsArticleSubscriptionsController < ApplicationController
  
  # POST /news_articles/:news_article_id/news_article_subscriptions
  def create
    news_article = NewsArticle.find(params[:news_article_id])
    if news_article_subscription_params[:source_type] == 'NewsCategory'
      source = NewsCategory.find_by!(id: news_article_subscription_params[:source_id])
    elsif news_article_subscription_params[:source_type] == 'Topic'
      source = Topic.find_by!(id: news_article_subscription_params[:source_id])
    else
      render json: { errors: ['Source type should be present.'] }, status: :unprocessable_entity
      return
    end
    
    news_article_subscription = NewsArticleSubscription.new(news_article: news_article)
    news_article_subscription.source = source
    if news_article_subscription.save
      render json: { success: true }, status: :ok
    else
      render json: { errors: news_article_subscription.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  private
    def news_article_subscription_params
      params.require(:news_article_subscription).permit(:source_id, :source_type)
    end
end
