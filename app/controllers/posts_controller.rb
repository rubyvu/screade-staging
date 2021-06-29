class PostsController < ApplicationController
  before_action :get_post, only: [:edit, :update, :destroy]
  before_action :get_groups, only: [:new, :edit]
  before_action :get_user_image, only: [:create, :update]
  protect_from_forgery except: [:update]
  
  # GET /posts
  def index
    if params[:username].present?
      @user = User.find_by!(username: params[:username])
      posts = @user.posts.where(is_approved: true)
    else
      @user = current_user
      posts = current_user.posts
    end
    
    @posts = posts.order(id: :desc).page(params[:page]).per(30)
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
    post.remote_image_url = @user_image&.file&.url
    post.user = current_user
    if post.save
      redirect_to posts_path
    end
  end
  
  # PUT/PATCH /posts/:id
  def update
    @post.remote_image_url = @user_image&.file&.url
    if @post.update(post_params)
      if @post.saved_changes[:is_notification].present?
        redirect_to post_post_comments_path(@post)
      else
        redirect_to posts_path
      end
    else
      redirect_back fallback_location: root_path
    end
  end
  
  # DELETE /posts/:id
  def destroy
    @post.destroy
    redirect_to posts_path
  end
  
  # GET /posts/user_images
  def user_images
    @user_images = current_user.user_images
    
    respond_to do |format|
      format.js { render 'user_images', layout: false }
    end
  end
  
  private
    def get_post
      @post = Post.find_by!(id: params[:id], user: current_user)
    end
    
    def get_groups
      @groups = NewsCategory.order(title: :asc)
      # @groups = NewsCategory.all + Topic.where(is_approved: true).or(Topic.where.not(is_approved: true).where(suggester: current_user))
    end
    
    def get_user_image
      @user_image = current_user.user_images.find_by(id: params[:post][:image_id])
    end
    
    def post_params
      strong_params = params.require(:post).permit(:image_id, :is_notification, :title, :description, :source, :virtual_source)
      
      source = strong_params[:source]
      if source.present?
        strong_params[:source_type], strong_params[:source_id] = source.split(':')
        strong_params.delete(:source)
      end
      
      strong_params.delete(:image_id)
      strong_params.delete(:virtual_source)
      strong_params
    end
end
