class UserVideoSerializer < ActiveModel::Serializer
  
  attribute :file_hex
  attribute :file_thumbnail
  def file_thumbnail
    object.file_thumbnail_url
  end
  
  attribute :file_url
  def file_url
    object.file_url
  end
  
  attribute :id
  attribute :is_private
end
