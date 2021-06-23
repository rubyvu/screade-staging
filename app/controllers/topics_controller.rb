class TopicsController < ApplicationController
  before_action :set_group
  protect_from_forgery except: [:new]
  
  def new
    @topic = Topic.new
    @topic.parent = @group
    
    respond_to do |format|
      format.js { render 'new', layout: false, redirect_path: params[:redirect_path] }
    end
  end
  
  def create
    redirect_path = params[:redirect_path]
    @topic = Topic.new(topic_params)
    @topic.suggester = current_user
    if @topic.save
      if redirect_path == 'posts'
        head :ok
      else
        render js: "window.location = '#{groups_path}'"
      end
    else
      render 'new', layout: false, redirect_path: redirect_path, status: :unprocessable_entity
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
