class Api::V1::GroupsController < Api::V1::ApiController
  before_action :set_source, only: [:subscribe, :unsubscribe]
  
  # GET /api/v1/groups
  def index
    groups_json = ActiveModel::Serializer::CollectionSerializer.new(NewsCategory.all + Topic.where(is_approved: true), serializer: GroupSerializer, current_user: current_user, news_article: nil).as_json
    render json: { groups: groups_json }, status: :ok
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
    news_categories_sql = NewsArticle.joins(:news_categories).where(news_categories: { id: current_user.subscribed_news_categories.ids }).to_sql
    topics_sql = NewsArticle.joins(:topics).where(topics: { id: current_user.subscribed_topics.ids }).to_sql
    source_ids = NewsArticle.from("(#{news_categories_sql} UNION #{topics_sql}) AS news_articles").order(id: :desc).limit(1000).ids
    comments = Comment.where('((source_type = ? AND source_id IN (?) AND comment_id IS NULL) OR (comment_id IN (?))) AND (user_id != ?)', 'NewsArticle', source_ids, current_user.comments.ids, current_user.id).order(id: :desc).page(params[:page]).per(30)
    
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
