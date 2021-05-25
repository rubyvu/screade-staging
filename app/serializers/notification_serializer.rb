class NotificationSerializer < ActiveModel::Serializer
  attribute :created_at
  def created_at
    object.created_at.strftime('%Y-%m-%d %H:%M:%S %z')
  end
  
  attribute :id
  attribute :is_viewed
  attribute :message
  attribute :source
  def source
    case object.source_type
    when 'Comment'
      CommentSerializer.new(object.source).as_json
    when 'Event'
      EventSerializer.new(object.source).as_json
    when 'Post'
      PostSerializer.new(object.source).as_json
    when 'UserImage'
      UserImageSerializer.new(object.source).as_json
    when 'UserVideo'
      UserVideoSerializer.new(object.source).as_json
    when 'SquadRequest'
      SquadRequestSerializer.new(object.source).as_json
    end
  end
  
  attribute :user
  def user
    UserProfileSerializer.new(object.sender).as_json
  end
end
