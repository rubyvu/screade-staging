class PostLitsController < ApplicationController
  before_action :get_post, only: [:create, :destroy]
  
  # POST /posts/:post_id/post_lits
  def create
    lit = Lit.new(source: @post, user: current_user)
    if lit.save
      render json: { success: true }, status: :ok
    else
      render json: { success: false }, status: :unprocessable_entity
    end
  end
  
  # DELETE /posts/:post_id/post_lits
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
