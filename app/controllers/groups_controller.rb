class GroupsController < ApplicationController
  before_action :set_group, only: [:subscribe, :unsubscribe]
  
  # GET /groups
  def index
    @subscriptions = nil
    @groups = NewsCategory.order(title: :asc)
    
  end
  
  # POST /groups/:id/subscribe
  def subscribe
    
  end
  
  # POST /groups/:id/unsubscribe
  def unsubscribe
    
  end
  
  private
    def set_group
      @group = Group.find(params[:id])
    end
end
