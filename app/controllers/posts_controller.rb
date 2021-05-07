class PostsController < ApplicationController
  before_action :get_post, only: [:edit, :update, :destroy]
  before_action :get_groups, only: [:new, :edit]
  
  # GET /posts
  def index
    @posts = current_user.posts
  end
  
  # GET /posts/new
  def new
    @post = Post.new(user: current_user)
  end
  
  # GET /posts/:id/edit
  def edit
  end
  
  # POST /posts
  def create
    post = Post.new(post_params)
    post.user = current_user
    if post.save
      redirect_to posts_path
    end
  end
  
  # PUT/PATCH /posts/:id
  def update
    if @post.update(post_params)
      redirect_to posts_path
    else
      redirect_back fallback_location: root_path
    end
  end
  
  # DELETE /posts/:id
  def destroy
    @post.destroy
    redirect_to posts_path
  end
  
  private
    def get_post
      @post = Post.find(params[:id])
    end
    
    def get_groups
      @groups = NewsCategory.all + Topic.where(is_approved: true).or(Topic.where.not(is_approved: true).where(suggester: current_user))
    end
    
    def post_params
      strong_params = params.require(:post).permit(:image, :title, :description, :source)
      
      source = strong_params[:source]
      if source.present?
        strong_params[:source_type], strong_params[:source_id] = source.split(':')
        strong_params.delete(:source)
      end
      
      strong_params
    end
end
