class UserSerializer < ActiveModel::Serializer
  
  attribute :banner_picture
  def banner_picture
    object&.banner_picture&.rectangle_300_250.url
  end
  
  attribute :birthday
  def birthday
    object&.birthday&.strftime('%Y-%m-%d')
  end
  
  attribute :comments_count
  def comments_count
    object&.comments_count
  end
  
  attribute :email
  attribute :first_name
  def images_exists
    user.user_images.present?
  end
  
  attribute :is_confirmed
  def is_confirmed
    object&.confirmed? || false
  end
  
  attribute :last_name
  attribute :languages
  def languages
    ActiveModel::Serializer::CollectionSerializer.new(object.languages, serializer: LanguageSerializer).as_json
  end
  
  attribute :lits_count
  def lits_count
    object&.lits_count
  end
  
  attribute :middle_name
  attribute :phone_number
  
  attribute :profile_picture
  def profile_picture
    object.profile_picture.square_320.url
  end
  
  attribute :videos_exists
  def videos_exists
    user.user_videos.present?
  end
  
  attribute :views_count
  def views_count
    # How many User posts viewd by another Users
    0
  end
  
  attribute :username
end
