class PostSerializer < ActiveModel::Serializer
  attribute :comments_count
  def comments_count
    object.comments.count
  end
  
  attribute :description
  attribute :id
  attribute :image
  def image
    object.image.rectangle_300_250.url
  end
  
  attribute :is_notification
  attribute :is_commented
  def is_commented
    current_user = instance_options[:current_user]
    current_user && current_user.kind_of?(User) ? object.is_commented(current_user) : false
  end
  
  attribute :is_lited
  def is_lited
    current_user = instance_options[:current_user]
    current_user && current_user.kind_of?(User) ? object.is_lited(current_user) : false
  end
  
  attribute :is_viewed
  def is_viewed
    current_user = instance_options[:current_user]
    current_user && current_user.kind_of?(User) ? object.is_viewed(current_user) : false
  end
  
  attribute :lits_count
  def lits_count
    object.lits.count
  end
  
  attribute :source
  def source
    PostGroupSerializer.new(object.source).as_json
  end
  
  attribute :title
  attribute :state
  
  attribute :views_count
  def views_count
    object.views.count
  end
  
  attribute :user
  def user
    current_user = instance_options[:current_user]
    UserProfileSerializer.new(object.user, current_user: current_user).as_json
  end
end
