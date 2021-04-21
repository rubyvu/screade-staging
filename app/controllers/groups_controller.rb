class GroupsController < ApplicationController
  before_action :set_group, only: [:subscribe, :unsubscribe]
  protect_from_forgery except: [:search]
  
  # GET /groups
  def index
    @subscriptions = nil
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
