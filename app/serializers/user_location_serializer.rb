# == Schema Information
#
# Table name: user_locations
#
#  id         :bigint           not null, primary key
#  latitude   :decimal(10, 6)   not null
#  longitude  :decimal(10, 6)   not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_user_locations_on_user_id  (user_id)
#
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
