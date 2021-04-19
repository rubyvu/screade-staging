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
  
  private
    def set_source
      if subscription_params[:source_type] == 'NewsCategory'
        @source = NewsCategory.find_by!(subscription_params)
      elsif subscription_params[:source_type] == 'Topic'
        @source = Topic.find_by!(subscription_params)
      else
        render json: { errors: ['Source type should be present.'] }, status: :unprocessable_entity
        return
      end
    end
    
    def subscription_params
      params.require(:user_topic_subscription).permit(:source_id, :source_type)
    end
end
