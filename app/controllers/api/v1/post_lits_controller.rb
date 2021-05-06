class Api::V1::PostLitsController < Api::V1::ApiController
  before_action :get_post, only: [:create, :destroy]
  
  # POST /api/v1/posts/:post_id/post_lits
  def create
    lit = Lit.new(source: @post, user: current_user)
    if lit.save
      post_json = PostSerializer.new(@post, current_user: current_user).as_json
      render json: { post: post_json }, status: :ok
    else
      render json: { errors: lit.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # DELETE /api/v1/posts/:post_id/post_lits
  def destroy
    lit = Lit.find_by!(source: @post, user: current_user)
    lit.destroy
    render json: { success: true }, status: :ok
  end
  
  private
    def get_post
      @post = Post.find(params[:post_id])
    end
end
