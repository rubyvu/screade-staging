class UserBlocksController < ApplicationController
  
  # POST /user_blocks
  def create
    user_block = UserBlock.new
    user_block.blocked_user_id = params[:user_id]
    user_block.blocker = current_user
    user_block.save
    
    redirect_to user_path(username: user_block.blocked.username)
  end
  
  # DELETE /user_blocks/:user_id
  def destroy
    blocked = User.find(params[:user_id])
    user_block = UserBlock.find_by!(blocker: current_user, blocked: blocked)
    
    user_block.destroy
    
    redirect_to user_path(username: blocked.username)
  end
end
