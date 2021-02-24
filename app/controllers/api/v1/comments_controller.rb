class Api::V1::CommentsController < Api::V1::ApiController
  before_action :get_comment
  
  # POST /api/v1/comments/:id/lit
  def lit
    lit = Lit.new(source: @comment, user: current_user)
    if lit.save
      comment_json = CommentSerializer.new(@comment, current_user: current_user).as_json
      render json: { comment: comment_json }, status: :ok
    else
      render json: { errors: lit.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # DELETE /api/v1/comments/:id/unlit
  def unlit
    lit = Lit.find_by!(source: @comment, user: current_user)
    lit.destroy
    
    comment_json = CommentSerializer.new(@comment, current_user: current_user).as_json
    render json: { comment: comment_json }, status: :ok
  end
  
  private
    def get_comment
      @comment = Comment.find(params[:id])
    end
end
