class Api::V1::GroupsController < Api::V1::ApiController
  
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
    
    render json: { group: groups }, status: :ok
  end
end
