class Api::V1::TopicsController < Api::V1::ApiController
  
  # GET /api/v1/topics/:id
  def show
    topic = Topic.find(params[:id])
    topic_json = TopicSerializer.new(topic).as_json
    render json: { topic: topic_json }, status: :ok
  end
  
  # POST /api/v1/topics
  def create
    topic = Topic.new(topic_params)
    if topic.save
      topic_json = TopicSerializer.new(topic).as_json
      render json: { topic: topic_json }, status: :ok
    else
      render json: { errors: topic.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  private
    def topic_params
      params.require(:topic).permit(:title, :parent_id, :parent_type)
    end
end
