class UserImageSerializer < ActiveModel::Serializer
  
  attribute :file_hex
  attribute :id
  attribute :rectangle_160_160_url
  def rectangle_160_160_url
    object.file.rectangle_160_160.url
  end
  
  attribute :rectangle_1024_768_url
  def rectangle_1024_768_url
    object.file.rectangle_1024_768.url
  end
end
