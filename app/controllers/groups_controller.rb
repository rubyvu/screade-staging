class GroupsController < ApplicationController
  before_action :set_group, only: [:subscribe, :unsubscribe]
  
  # GET /groups
  def index
    @subscriptions = nil
    @groups = NewsCategory.order(title: :asc)
    
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
