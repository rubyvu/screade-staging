class UserSerializer < ActiveModel::Serializer
  
  attribute :banner_picture
  def banner_picture
    object&.banner_picture_url
  end
  
  attribute :birthday
  def birthday
    object&.birthday&.strftime('%Y-%m-%d')
  end
  
  attribute :country_code
  def country_code
    object&.country.code
  end
  
  attribute :comments_count
  def comments_count
    object&.comments_count
  end
  
  attribute :email
  attribute :first_name
  attribute :id
  
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
    object.profile_picture_url
  end
  
  attribute :squad_members_count
  def squad_members_count
    object.count_squad_members
  end
  
  attribute :squad_requests_count
  def squad_requests_count
    object.count_squad_requests
  end
  
  attribute :views_count
  def views_count
    object&.views_count
  end
  
  attribute :username
end
