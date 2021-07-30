class MapsController < ApplicationController
  
  # GET /maps
  def index
    current_user_location = nil
    current_user_location = UserLocationSerializer.new(current_user).as_json if current_user.user_location.present? && current_user.setting.is_current_location
    
    # Get Squad Users that have UserLocation and is_current_location set to true
    squad_receivers_sql = User.joins(:squad_requests_as_receiver).where(squad_requests_as_receiver: { requestor: current_user }).where.not(squad_requests_as_receiver: { accepted_at: nil }).joins(:user_location, :setting).where(setting: { is_current_location: true }).to_sql
    squad_requestors_sql = User.joins(:squad_requests_as_requestor).where(squad_requests_as_requestor: { receiver: current_user }).where.not(squad_requests_as_requestor: { accepted_at: nil }).joins(:user_location, :setting).where(setting: { is_current_location: true }).to_sql
    squad_members_with_location = User.from("(#{squad_receivers_sql} UNION #{squad_requestors_sql}) AS users")
    
    squad_members_locations_json = ActiveModel::Serializer::CollectionSerializer.new(squad_members_with_location, serializer: UserLocationSerializer).as_json
    
    respond_to do |format|
      format.html
      format.json { render json: {current_user_location: current_user_location, squad_members_locations: squad_members_locations_json }, status: :ok }
    end
  end
end
