class Api::V1::UserBlocksController < Api::V1::ApiController
  
  # GET /api/v1/user_blocks
  def index
    user_blocks_json = ActiveModel::Serializer::CollectionSerializer.new(current_user.user_blocks_as_blocker, serializer: UserBlockSerializer).as_json
    render json: { user_blocks: user_blocks_json }, status: :ok
  end
  
  # POST /api/v1/user_blocks
  def create
    user_block = UserBlock.new(user_block_params)
    user_block.blocker = current_user
    user_block.save
    
    user_block_json = UserBlockSerializer.new(user_block).as_json
    render json: { user_block: user_block_json }, status: :created
  end
  
  # DELETE /api/v1/user_blocks/:id
  def destroy
    user_block = UserBlock.find(params[:id])
    user_block_json = UserBlockSerializer.new(user_block).as_json
    
    user_block.destroy
    render json: { user_block: user_block_json }, status: :ok
  end
  
  private
    def user_block_params
      params.require(:user_block).permit(:blocked_user_id)
    end
end
