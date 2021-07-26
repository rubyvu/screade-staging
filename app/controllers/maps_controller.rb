class MapsController < ApplicationController
  
  # GET /maps
  def index
    @current_user_location = { latitude: 50.9216, longitude: 34.8003 }
    @squad_members_locations = [
      { latitude: 50.9316, longitude: 34.9003, profile_picture_url: User.find(91).profile_picture.url, full_name: User.find(91).full_name },
      { latitude: 51.9216, longitude: 35.8003, profile_picture_url: User.find(91).profile_picture.url, full_name: User.find(91).full_name },
      { latitude: 51.9216, longitude: 36.8003, profile_picture_url: User.find(91).profile_picture.url, full_name: User.find(91).full_name },
      { latitude: 51.9216, longitude: 37.8003, profile_picture_url: User.find(91).profile_picture.url, full_name: User.find(91).full_name }
    ]
    
    @location_setting = Setting.get_setting(current_user)
    
    respond_to do |format|
      format.html
      format.json { render json: {current_user_location: @current_user_location, squad_members_locations: @squad_members_locations }, status: :ok }
    end
  end
end
