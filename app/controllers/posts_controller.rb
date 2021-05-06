class PostsController < ApplicationController
  before_action :get_post, only: [:edit, :update, :destroy]
  
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
  
  # POST /events
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
  
  # DELETE /events/:id
  def destroy
    @post.destroy
    redirect_to posts_path
  end
  
  private
    def get_post
      @post = Post.find(params[:id])
    end
    
    def post_params
      params.require(:post).permit(:image, :title, :description, :news_category_id, :topic_id)
    end
end
