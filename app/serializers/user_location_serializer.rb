class UserLocationSerializer < ActiveModel::Serializer
  
  attribute :banner_picture
  def banner_picture
    object&.banner_picture&.rectangle_300_250.url
  end
  
  attribute :username
  def full_name
    object.username
  end
  
  attribute :latitude
  def latitude
    object.user_location&.latitude
  end
  
  attribute :longitude
  def longitude
    object.user_location&.longitude
  end
end
