class PostCommentsController < ApplicationController
  before_action :get_post, only: [:index, :create]
  
  # GET /posts/:posts_id/post_comments
  def index
    @post_comment = Comment.new()
    @comments = Comment.where(source: @post, comment_id: nil).order(created_at: :desc)
  end
  
  # POST /posts/:posts_id/post_comments
  def create
    new_comment = Comment.new(comment_params)
    new_comment.source = @post
    new_comment.user = current_user
    new_comment.save
    if new_comment.comment.present?
      redirect_to post_comment_reply_comments_path(post_id: @post.id, comment_id: new_comment.comment.id )
    else
      redirect_to comments_news_article_path(@post)
    end
  end
  
  # GET /posts/:posts_id/post_comments/:comment_id/reply_comments
  def reply_comments
    comment = Comment.find(params[:comment_id])
    @new_comment = Comment.new(comment: comment)
    @news_article = comment.source
    @comments = comment.replied_comments.order(created_at: :desc)
  end
  
  private
    def get_post
      @post = Post.find(params[:post_id])
    end
    
    def comment_params
      params.require(:comment).permit(:comment_id, :message)
    end
end
