class StreamsController < ApplicationController
  
  # GET /posts
  def index
    @streams = Stream.where(user: current_user).order(updated_at: :desc).page(params[:page]).per(30)
  end
  
  # GET /posts
  def create
    
  end
end
