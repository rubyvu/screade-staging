class StreamLitsController < ApplicationController
  before_action :get_stream, only: [:create, :destroy]
  
  # POST /streams/:access_token/stream_lits
  def create
    lit = Lit.new(source: @stream, user: current_user)
    if lit.save
      render json: { success: true }, status: :ok
    else
      render json: { success: false }, status: :unprocessable_entity
    end
  end
  
  # DELETE /streams/:access_token/stream_lits
  def destroy
    lit = Lit.find_by!(source: @stream, user: current_user)
    lit.destroy
    render json: { success: true }, status: :ok
  end
  
  private
    def get_stream
      @stream = Stream.find_by!(access_token: params[:stream_access_token])
    end
end
