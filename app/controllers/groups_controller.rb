class GroupsController < ApplicationController
  before_action :set_group, only: [:subscribe, :unsubscribe]
  protect_from_forgery except: [:search]
  
  # GET /groups
  def index
    # TODO add Time params to subscribed_news_articles: .where('news_articles.created_at >= ?', 1.week.ago)
    subscribed_news_articles = NewsArticle.joins(:news_categories).where(news_categories: current_user.subscripted_news_categories) + NewsArticle.joins(:topics).where(topics: current_user.subscripted_topics)
    @comments = Comment.where(source_type: 'NewsArticle', source: subscribed_news_articles, comment_id: nil).where.not(user: current_user).or(Comment.where(comment_id: current_user.comments.ids).where.not(user: current_user)).order(created_at: :desc).limit(100)
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
end
