class UserProfileSerializer < ActiveModel::Serializer
  
  attribute :banner_picture
  def banner_picture
    object&.banner_picture&.rectangle_300_250.url
  end
  
  attribute :comments_count
  def comments_count
    object&.comments_count
  end
  
  attribute :first_name
  
  attribute :font_family
  def font_family
    Setting.get_setting(object).font_family
  end
  
  attribute :font_style
  def font_style
    Setting.get_setting(object).font_style
  end
  
  attribute :is_images
  def is_images
    Setting.get_setting(object).is_images
  end
  
  attribute :is_videos
  def is_videos
    Setting.get_setting(object).is_videos
  end
  
  attribute :is_posts
  def is_posts
    Setting.get_setting(object).is_posts
  end
  
  attribute :last_name
  
  attribute :lits_count
  def lits_count
    object&.lits_count
  end
  
  attribute :middle_name
  
  attribute :profile_picture
  def profile_picture
    object.profile_picture.square_320.url
  end
  
  attribute :views_count
  def views_count
    # How many User posts viewd by another Users
    0
  end
  
  attribute :username
end
