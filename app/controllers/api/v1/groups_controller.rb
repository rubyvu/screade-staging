class Api::V1::TopicsController < Api::V1::ApiController
  
  # GET /api/v1/groups
  def index
    # TODO: Correct request here
    render json: { group: group_json }, status: :ok
  end
end
