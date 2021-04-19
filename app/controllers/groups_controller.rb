class GroupsController < ApplicationController
  before_action :set_group, only: [:subscribe, :unsubscribe]
  
  # GET /groups
  def index
    @subscriptions = nil
    @groups = NewsCategory.order(title: :asc)
    
  end
  
  # POST /groups/:id/subscribe
  def subscribe
    subscription = UserTopicSubscription.new(source: @group, user: current_user)
    if subscription.save
      render json: { success: true }, status: :ok
    else
      render json: { success: false }, status: :ok
    end
  end
  
  # POST /groups/:id/unsubscribe
  def unsubscribe
    subscription = UserTopicSubscription.find_by!(source: @group, user: current_user)
    subscription.destroy
    render json: { success: true }, status: :ok
  end
  
  private
    def set_group
      @group = Group.find(params[:id])
    end
end
