class Api::V1::PostsController < Api::V1::ApiController
  before_action :get_post, only: [:show, :update, :destroy]
  before_action :get_user_image, only: [:create, :update]
  
  # GET /api/v1/posts
  def index
    if params[:username].present?
      user = User.find_by!(username: params[:username])
      posts = user.posts.where(is_approved: true)
    else
      posts = current_user.posts
    end
    
    posts_json = ActiveModel::Serializer::CollectionSerializer.new(posts.order(created_at: :desc).page(params[:page]).per(30), serializer: PostSerializer, current_user: current_user).as_json
    render json: { posts: posts_json }, status: :ok
  end
  
  # GET /api/v1/posts/:id
  def show
    View.find_or_create_by(source: @post, user: current_user)
    post_json = PostSerializer.new(@post, current_user: current_user).as_json
    render json: { post: post_json }, status: :ok
  end
  
  # POST /api/v1/posts
  def create
    post = Post.new(post_params)
    post.remote_image_url = @user_image&.file&.url
    post.user = current_user
    if post.save
      post_json = PostSerializer.new(post, current_user: current_user).as_json
      render json: { post: post_json }, status: :ok
    else
      render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # PUT/PATCH /api/v1/posts/:id
  def update
    @post.remote_image_url = @user_image&.file&.url
    if @post.update(post_params)
      post_json = PostSerializer.new(@post, current_user: current_user).as_json
      render json: { post: post_json }, status: :ok
    else
      render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # DELETE /api/v1/posts/:id
  def destroy
    @post.destroy
    render json: { success: true }, status: :ok
  end
  
  private
    def get_post
      @post = Post.find(params[:id])
    end
    
    def get_user_image
      @user_image = current_user.user_images.find_by(id: params[:post][:image_id])
    end
    
    def post_params
      strong_params = params.require(:post).permit(:image_id, :is_notification, :title, :description, :source_type, :source_id)
      strong_params.delete(:image_id)
      strong_params
    end
end
