class Api::V1::UserLocationsController < Api::V1::ApiController
  
  # GET /api/v1/user_locations
  def index
    current_user_location = UserLocationSerializer.new(current_user).as_json
    
    # Get Squad Users that have UserLocation and is_current_location set to true
    squad_receivers_sql = User.joins(:squad_requests_as_receiver).where(squad_requests_as_receiver: { requestor: current_user }).where.not(squad_requests_as_receiver: { accepted_at: nil }).joins(:user_location, :setting).where(setting: { is_current_location: true }).to_sql
    squad_requestors_sql = User.joins(:squad_requests_as_requestor).where(squad_requests_as_requestor: { receiver: current_user }).where.not(squad_requests_as_requestor: { accepted_at: nil }).joins(:user_location, :setting).where(setting: { is_current_location: true }).to_sql
    squad_members_with_location = User.from("(#{squad_receivers_sql} UNION #{squad_requestors_sql}) AS users")
    
    squad_members_locations_json = ActiveModel::Serializer::CollectionSerializer.new(squad_members_with_location, serializer: UserLocationSerializer).as_json
    render json: {current_user_location: current_user_location, squad_members_locations: squad_members_locations_json }, status: :ok
  end
  
  # POST /api/v1/user_locations
  def create
    user_location = UserLocation.get_location(current_user)
    user_location = UserLocation.new(user: current_user) if user_location.blank?
    user_location.latitude = user_location_params[:latitude]
    user_location.longitude = user_location_params[:longitude]
    
    if user_location.save
      user_location_json = UserLocationSerializer.new(current_user).as_json
      render json: { user_location: user_location_json }, status: :ok
    else
      render json: { errors: user_location.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  private
    def user_location_params
      params.require(:user_locations).permit(:latitude, :longitude)
    end
end
