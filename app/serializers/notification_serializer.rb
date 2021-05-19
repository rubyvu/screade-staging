class NotificationSerializer < ActiveModel::Serializer
  attribute :id
  attribute :is_viewed
  attribute :message
  attribute :source
  def source
    case source_type
    when 'User'
      ''
    end
  end
  
  attribute :user
  def user
    UserSerializer.new(object.user).as_json
  end
end
