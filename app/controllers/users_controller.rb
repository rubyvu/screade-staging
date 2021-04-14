class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  
  # GET /users/:username
  def show
    options = {}
    options[:is_private] = false if @user != current_user
    
    @squad_request = @user.squad_requests_as_receiver.where(requestor: current_user, declined_at: nil).or(@user.squad_requests_as_requestor.where(receiver: current_user, declined_at: nil)).first
    @images = @user.user_images.where(options).order(updated_at: :desc).limit(6)
    @videos = @user.user_videos.where(options).order(updated_at: :desc).limit(6)
  end
  
  private
    def set_user
      @user = User.find_by!(username: params[:username])
    end
end
