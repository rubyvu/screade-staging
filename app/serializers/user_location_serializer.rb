class UserLocationSerializer < ActiveModel::Serializer
  
  attribute :banner_picture
  def banner_picture
    object&.banner_picture&.rectangle_300_250.url
  end
  
  attribute :full_name
  def full_name
    object.full_name
  end
  
  attribute :latitude
  def latitude
  end
  
  attribute :longitude
  def longitude
  end
end
