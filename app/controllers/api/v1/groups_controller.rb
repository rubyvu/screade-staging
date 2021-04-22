class Api::V1::GroupsController < Api::V1::ApiController
  before_action :set_source, only: [:subscribe, :unsubscribe]
  
  # GET /api/v1/groups
  def index
    groups = []
    
    # All NewsCategories(tree root elements)
    NewsCategory.all.each do |news_category|
      groups << {
        type: 'NewsCategory',
        id: news_category.id,
        title: news_category.title,
        image: news_category.image.url,
        is_subscription: current_user.is_group_subscription(news_category),
        subscriptions_count: current_user.group_subscription_counts(news_category),
        parent_type: nil,
        parent_id: nil,
        nesting_position: 0
      }
    end
    
    # All approved Topics
    Topic.where(is_approved: true).each do |topic|
      groups << {
        type: 'Topic',
        id: topic.id,
        title: topic.title,
        image: nil,
        is_subscription: current_user.is_group_subscription(topic),
        subscriptions_count: nil,
        parent_type: topic.parent_type,
        parent_id: topic.parent_id,
        nesting_position: topic.nesting_position+1
      }
    end
    
    render json: { groups: groups }, status: :ok
  end
  
  # POST /api/v1/groups/subscribe
  def subscribe
    user_topic_subscription = UserTopicSubscription.new(user: current_user)
    user_topic_subscription.source = @source
    if user_topic_subscription.save
      render json: { success: true }, status: :ok
    else
      render json: { errors: user_topic_subscription.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # DELETE /api/v1/groups/unsubscribe
  def unsubscribe
    user_topic_subscription = current_user.user_topic_subscriptions.find_by(source: @source)
    user_topic_subscription.delete
    render json: { success: true }, status: :ok
  end
  
  # GET /api/v1/groups/comments
  def comments
    # Get all comments in NewsArticles that have associations with NewsCategories or Topics + Replyed Comments for Current User Comment
    subscribed_news_articles = NewsArticle.joins(:news_categories).where(news_categories: current_user.subscripted_news_categories) + NewsArticle.joins(:topics).where(topics: current_user.subscripted_topics)
    
    comments = Comment.where(source_type: 'NewsArticle', source: subscribed_news_articles).or(Comment.where(comment_id: current_user.comments.ids).where.not(user: current_user)).page(params[:page]).per(30)
    comments_json = ActiveModel::Serializer::CollectionSerializer.new(comments, current_user: current_user).as_json
    render json: { comments: comments_json }, status: :ok
  end
  
  private
    def set_source
      if subscription_params[:parent_type] == 'NewsCategory'
        @source = NewsCategory.find_by!(id: subscription_params[:parent_id])
      elsif subscription_params[:parent_type] == 'Topic'
        @source = Topic.find_by!(id: subscription_params[:parent_id])
      else
        render json: { errors: ['Source type should be present.'] }, status: :unprocessable_entity
        return
      end
    end
    
    def subscription_params
      params.require(:user_topic_subscription).permit(:parent_id, :parent_type)
    end
end
