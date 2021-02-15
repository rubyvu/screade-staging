class UserSerializer < ActiveModel::Serializer
  
  attribute :banner_picture
  def banner_picture
    object.banner_picture.rectangle_300_250.url
  end
  
  attribute :birthday
  def birthday
    object.birthday&.strftime('%Y-%m-%d')
  end
  
  attribute :email
  attribute :first_name
  attribute :is_confirmed
  def is_confirmed
    object.confirmed?
  end
  
  attribute :last_name
  attribute :middle_name
  attribute :phone_number
  
  attribute :profile_picture
  def profile_picture
    object.profile_picture.square_320.url
  end
  attribute :username
end
