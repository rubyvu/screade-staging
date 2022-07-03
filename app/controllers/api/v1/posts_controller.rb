class Api::V1::PostsController < Api::V1::ApiController
  before_action :get_post, only: [:show, :update, :destroy, :lits, :share, :translate]
  before_action :get_user_image, only: [:create, :update]
  before_action :get_user_video, only: [:create, :update]
  
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
    post.user = current_user
    
    if post.save
      # Attach UserImage file as Post image
      if @user_image&.file&.attached?
        @user_image.file.open do |file|
          post.image.attach(io: file, filename: SecureRandom.hex(16))
        end
      end
      
      # Attach UserVideo file as Post video
      if @user_video&.file&.attached?
        @user_video.file.open do |file|
          post.video.attach(io: file, filename: SecureRandom.hex(16))
        end
      end
      
      post_json = PostSerializer.new(post, current_user: current_user).as_json
      render json: { post: post_json }, status: :ok
    else
      render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # PUT/PATCH /api/v1/posts/:id
  def update
    if @post.update(post_params)
      # Attach UserImage file as Post image
      if @user_image&.file&.attached?
        @user_image.file.open do |file|
          post.image.attach(io: file, filename: SecureRandom.hex(16))
        end
      end
      
      # Attach UserVideo file as Post video
      if @user_video&.file&.attached?
        @user_video.file.open do |file|
          post.video.attach(io: file, filename: SecureRandom.hex(16))
        end
      end
      
      post_json = PostSerializer.new(@post, current_user: current_user).as_json
      render json: { post: post_json }, status: :ok
    else
      render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # DELETE /api/v1/posts/:id
  def destroy
    unless @post.user == current_user
      return render json: { success: false }, status: :forbidden
    end
    
    @post.destroy
    render json: { success: true }, status: :ok
  end
  
  # GET /api/v1/posts/:id/lits
  def lits
    lits_json = ActiveModel::Serializer::CollectionSerializer.new(@post.lits, serializer: LitSerializer, current_user: current_user).as_json
    render json: { lits: lits_json }, status: :ok
  end
  
  # POST /api/v1/posts/:id/share
  def share
    shared_record = SharedRecord.new(shared_record_params)
    shared_record.sender = current_user
    shared_record.shareable = @post
    
    if shared_record.save
      shared_record_json = SharedRecordSerializer.new(shared_record).as_json
      render json: { shared_record: shared_record_json }, status: :created
    else
      render json: { errors: shared_record.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # POST /api/v1/posts/:id/translate
  def translate
    post_translation = PostsService.new(@post).translate_for(current_user)
    render json: { post: post_translation }, status: :ok
  end
  
  private
    def get_post
      @post = Post.find(params[:id])
    end
    
    def get_user_image
      @user_image = current_user.user_images.find_by(id: params[:post][:image_id])
    end
    
    def get_user_video
      @user_video = current_user.user_videos.find_by(id: params[:post][:video_id])
    end
    
    def shared_record_params
      params.require(:shared_record).permit(user_ids: [])
    end
    
    def post_params
      strong_params = params.require(:post).permit(:image_id, :video_id, :title, :description, :source_type, :source_id)
      strong_params.delete(:image_id)
      strong_params.delete(:video_id)
      strong_params
    end
end
