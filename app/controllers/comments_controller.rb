class CommentsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:reply_comments]
  before_action :get_comment, only: [:lit, :unlit]
  
  # GET /news_articles/:news_article_id/comments/:comment_id/reply_comments
  def reply_comments
    comment = Comment.find(params[:comment_id])
    @new_comment = Comment.new(comment: comment)
    @news_article = comment.source
    @comments = comment.replied_comments.order(created_at: :desc)
  end
  
  # POST /comments/:id/lit
  def lit
    lit = Lit.new(source: @comment, user: current_user)
    if lit.save
      render json: { success: true }, status: :ok
    else
      render json: { success: false }, status: :ok
    end
  end
  
  # DELETE /comments/:id/unlit
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
