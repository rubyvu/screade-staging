class Api::V1::UserBlocksController < Api::V1::ApiController
  
  # GET /api/v1/user_blocks
  def index
    user_blocks_json = ActiveModel::Serializer::CollectionSerializer.new(current_user.user_blocks_as_blocker, serializer: UserBlockSerializer, current_user: current_user).as_json
    render json: { user_blocks: user_blocks_json }, status: :ok
  end
  
  # POST /api/v1/user_blocks
  def create
    user_block = UserBlock.new(user_block_params)
    user_block.blocker = current_user
    user_block.save
    
    user_block_json = UserBlockSerializer.new(user_block, current_user: current_user).as_json
    render json: { user_block: user_block_json }, status: :created
  end
  
  # DELETE /api/v1/user_blocks/:user_id
  def destroy
    blocked = User.find(params[:user_id])
    user_block = UserBlock.find_by!(blocker: current_user, blocked: blocked)
    user_block_json = UserBlockSerializer.new(user_block, current_user: current_user).as_json
    
    user_block.destroy
    render json: { user_block: user_block_json }, status: :ok
  end
  
  private
    def user_block_params
      params.require(:user_block).permit(:blocked_user_id)
    end
end
