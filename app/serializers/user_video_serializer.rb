class UserVideoSerializer < ActiveModel::Serializer
  
  attribute :file_hex
  attribute :file_url
  def file_url
    object.file.url
  end
  
  attribute :id
end
