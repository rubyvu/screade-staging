class Api::V1::PostsController < Api::V1::ApiController
  before_action :get_post, only: [:show, :update, :destroy]
  
  # GET /api/v1/posts
  def index
    posts_json = ActiveModel::Serializer::CollectionSerializer.new(current_user.posts, serializer: PostSerializer, current_user: current_user).as_json
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
    post.user = current_user
    if post.save
      post_json = PostSerializer.new(post).as_json
      render json: { post: post_json }, status: :ok
    else
      render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # PUT/PATCH /api/v1/posts/:id
  def update
    if @post.update(post_params)
      post_json = PostSerializer.new(@post).as_json
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
    
    def post_params
      params.require(:post).permit(:image, :title, :description, :source_type, :source_id)
    end
end
