class CommentsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:reply_comments]
  before_action :get_comment, only: [:lits, :lit, :unlit, :translate]
  
  # DELETE /comments/:id
  def destroy
    comment = Comment.find(params[:id])
    unless comment.user == current_user
      redirect_to root_path
    end
    
    source_id = comment.source_id
    source_type = comment.source_type
    
    comment.destroy
    
    if source_type == 'Post'
      post = Post.find(source_id)
      
      if comment.comment_id
        return redirect_to post_post_comment_reply_comments_path(post_id: post.id, post_comment_id: comment.comment.id)
      else
        return redirect_to post_post_comments_path(post)
      end
    elsif source_type == 'NewsArticle'
      news_article = NewsArticle.find(source_id)
      
      if comment.comment_id
        return redirect_to news_article_comment_reply_comments_path(news_article_id: news_article.id, comment_id: comment.comment.id)
      else
        return redirect_to comments_news_article_path(news_article)
      end
    end
    
    redirect_to root_path
  end
  
  # GET /comments/:id/lits
  def lits
    respond_to do |format|
      format.js { render 'lits', layout: false }
    end
  end
  
  # GET /news_articles/:news_article_id/comments/:comment_id/reply_comments
  def reply_comments
    comment = Comment.find(params[:comment_id])
    @new_comment = Comment.new(source_type: 'NewsArticle', comment: comment)
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
  
  # GET /comments/:id/translate
  def translate
    comment_translation = CommentsService.new(@comment).translate_for(current_user)
    render json: { comment: comment_translation }, status: :ok
  end
  
  private
    def get_comment
      @comment = Comment.find(params[:id])
    end
end
