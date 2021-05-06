class TopicsController < ApplicationController
  before_action :set_group
  protect_from_forgery except: [:new]
  
  def new
    @topic = Topic.new
    @topic.parent = @group
    
    respond_to do |format|
      format.js { render 'new', layout: false }
    end
  end
  
  def create
    @topic = Topic.new(topic_params)
    if @topic.save
      render js: "window.location = '#{groups_path}'"
    else
      render 'new', layout: false
    end
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
    
    def topic_params
      params.require(:topic).permit(:parent_id, :parent_type, :title)
    end
end
