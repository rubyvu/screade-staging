class UserLocationSerializer < ActiveModel::Serializer
  
  attribute :profile_picture
  def profile_picture
    object&.profile_picture_url || ActionController::Base.helpers.asset_pack_path('media/images/placeholders/placeholder-user-profile.png')
  end
  
  attribute :username
  def full_name
    object.username
  end
  
  attribute :latitude
  def latitude
    object.user_location&.latitude.to_f
  end
  
  attribute :longitude
  def longitude
    object.user_location&.longitude.to_f
  end
end
