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
  
  # GET /users/:username
  def edit
    @user = current_user
  end
  
  # PATCH /users/change_password
  def change_password
    @user = current_user
    old_password = user_params[:old_password]
    password = user_params[:password]
    password_confirmation = user_params[:password_confirmation]
    
    unless @user.valid_password?(old_password)
      flash[:error] = ['Old password is wrong']
      render 'edit'
      return
    end
    
    if password != password_confirmation
      flash[:error] = ['The password confirmation does not match']
      render 'edit'
      return
    end
    
    if @user.update(user_params.except(:old_password))
      bypass_sign_in(@user)
      redirect_to root_path
    else
      flash[:error] = @user.errors.full_messages
      render 'edit'
    end
  end
  
  private
    def set_user
      @user = User.find_by!(username: params[:username])
    end
    
    def user_params
      params.require(:user).permit(:old_password, :password, :password_confirmation)
    end
end
