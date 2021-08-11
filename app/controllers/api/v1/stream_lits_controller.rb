class Api::V1::StreamLitsController < Api::V1::ApiController
  before_action :get_stream, only: [:create, :destroy]
  
  # POST /api/v1/sterams/:stream_access_token/stream_lits
  def create
    lit = Lit.new(source: @stream, user: current_user)
    if lit.save
      stream_json = StreamSerializer.new(@stream, current_user: current_user).as_json
      render json: { stream: stream_json }, status: :ok
    else
      render json: { errors: lit.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # DELETE /api/v1/sterams/:stream_access_token/stream_lits
  def destroy
    lit = Lit.find_by!(source: @stream, user: current_user)
    lit.destroy
    stream_json = StreamSerializer.new(@stream, current_user: current_user).as_json
    render json: { stream: stream_json }, status: :ok
  end
  
  private
    def get_stream
      @stream = Stream.find(params[:stream_access_token])
    end
end
