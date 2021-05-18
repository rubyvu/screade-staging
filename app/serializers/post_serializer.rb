class PostSerializer < ActiveModel::Serializer
  attribute :description
  attribute :id
  attribute :image
  def image
    object.image.rectangle_300_250.url
  end
  
  attribute :is_notification
  attribute :source
  def source
    PostGroupSerializer.new(object.source).as_json
  end
  
  attribute :title
  attribute :state
  attribute :user
  def user
    current_user = instance_options[:current_user]
    UserProfileSerializer.new(object.user, current_user: current_user).as_json
  end
end
