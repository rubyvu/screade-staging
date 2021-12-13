class SharedRecordsController < ApplicationController
  
  # GET /shared_records
  def index
    if params[:comment_id]
      @shareable = Comment.find(params[:comment_id])
    elsif params[:news_article_id]
      @shareable = NewsArticle.find(params[:news_article_id])
    elsif params[:post_id]
      @shareable = Post.find(params[:post_id])
    end
    
    squad_receivers_sql = User.joins(:squad_requests_as_receiver).where(squad_requests_as_receiver: { requestor: current_user })
                                                                 .where.not(squad_requests_as_receiver: { accepted_at: nil }).to_sql
    squad_requestors_sql = User.joins(:squad_requests_as_requestor).where(squad_requests_as_requestor: { receiver: current_user })
                                                                   .where.not(squad_requests_as_requestor: { accepted_at: nil }).to_sql
    @squad_members = User.from("(#{squad_receivers_sql} UNION #{squad_requestors_sql}) AS users")
    
    respond_to do |format|
      format.js { render 'index', layout: false }
    end
  end
  
  # POST /shared_records
  def create
    shared_record = SharedRecord.new(shared_record_params)
    shared_record.sender = current_user
    shared_record.save
    
    if shared_record.shareable.is_a?(Comment)
      comment = shared_record.shareable
      if comment.source_type == 'NewsArticle'
        return redirect_to comments_news_article_path(comment.source)
      elsif comment.source_type == 'Post'
        return redirect_to post_post_comments_path(comment.source)
      end
    elsif shared_record.shareable.is_a?(NewsArticle)
      return redirect_to comments_news_article_path(shared_record.shareable)
    elsif shared_record.shareable.is_a?(Post)
      return redirect_to post_post_comments_path(shared_record.shareable)
    end
    
    redirect_to root_path
  end
  
  private
    def shared_record_params
      params.require(:shared_record).permit(:shareable_id, :shareable_type, user_ids: [])
    end
end
