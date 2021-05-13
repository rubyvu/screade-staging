class GroupsController < ApplicationController
  before_action :set_group, only: [:subscribe, :unsubscribe]
  before_action :set_subscriptions, only: [:index, :subscriptions]
  protect_from_forgery except: [:search]
  
  # GET /groups
  def index
    @groups = NewsCategory.order(title: :asc)
  end
  
  # GET /groups/search
  def search
    @groups_for_search = []
    (NewsCategory.all + Topic.where(is_approved: true)).each do |group|
      @groups_for_search << group
    end
    
    respond_to do |format|
      format.js { render 'search', layout: false }
    end
  end
  
  # GET /groups/subscriptions
  def subscriptions
    respond_to do |format|
      format.js { render 'comments', layout: false }
    end
  end
  
  # POST /groups/subscribe
  def subscribe
    subscription = UserTopicSubscription.new(source: @group, user: current_user)
    if subscription.save
      render json: { success: true }, status: :ok
    else
      render json: { success: false }, status: :ok
    end
  end
  
  # DELETE /groups/unsubscribe
  def unsubscribe
    subscription = UserTopicSubscription.find_by!(source: @group, user: current_user)
    subscription.destroy
    render json: { success: true }, status: :ok
  end
  
  private
    def set_group
      case params[:type]
      when 'NewsCategory'
        @group = NewsCategory.find_by(id: params[:id])
      when 'Topic'
        @group = Topic.find_by(id: params[:id])
      else
        @group = nil
      end
    end
    
    def set_subscriptions
      # Get Source from NewsArticles
      news_categories_sql = NewsArticle.joins(:news_categories, :comments).where(news_categories: { id: current_user.subscribed_news_categories.ids }).to_sql
      topics_sql = NewsArticle.joins(:topics, :comments).where(topics: { id: current_user.subscribed_topics.ids }).to_sql
      source_ids = NewsArticle.from("(#{news_categories_sql} UNION #{topics_sql}) AS news_articles").order(id: :desc).limit(1000).ids
      
      # Get Source from Post
      topic_posts_ids = Topic.joins(:post_groups).where(post_groups: { id: current_user.post_groups.where(group_type: 'Topic').ids }).distinct.ids
      news_category_posts_ids = NewsCategory.joins(:post_groups).where(post_groups: { id: current_user.post_groups.where(group_type: 'NewsCategory').ids }).distinct.ids
      post_source_ids = Post.where(source_type: 'Topic', source_id: topic_posts_ids)
                            .or(Post.where(source_type: 'NewsCategory', source_id: news_category_posts_ids))
                            .order(id: :desc).limit(1000).ids
                            
      @comments = Comment.where(source_type: 'NewsArticle', source_id: source_ids, comment_id: nil).where.not(user: current_user)
                          .or(Comment.where(source_type: 'Post', source_id: post_source_ids, comment_id: nil).where.not(user: current_user))
                          .or(Comment.where(comment_id: current_user.comments.ids).where.not(user: current_user))
                          .order(created_at: :desc).limit(100)
    end
end
