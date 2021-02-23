class Api::V1::CommentsController < Api::V1::ApiController
  before_action :get_comment
  
  # POST /api/v1/comments/:id/lit
  def lit
    lit = Lit.new(source: @comment, user: current_user)
    if lit.save
      render json: { success: true }, status: :ok
    else
      render json: { success: false }, status: :ok
    end
  end
  
  # DELETE /api/v1/comments/:id/unlit
  def unlit
    lit = Lit.find_by!(source: @comment, user: current_user)
    lit.destroy
    render json: { success: true }, status: :ok
  end
  
  private
    def get_comment
      @comment = Comment.find(params[:id])
    end
end
