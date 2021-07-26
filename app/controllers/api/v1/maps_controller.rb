class Api::V1::MapsController < Api::V1::ApiController
  
  # GET /api/v1/maps
  def index
    current_user_location = UserLocationSerializer.new(current_user).as_json
    members = [] # All members where location can be showed (from settings)
    squad_members_locations = ActiveModel::Serializer::CollectionSerializer.new(members, serializer: ChatMembershipSeUserLocationSerializerrializer).as_json
    
    render json: {current_user_location: current_user_location, squad_members_locations: squad_members_locations }, status: :ok
end
