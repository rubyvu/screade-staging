class NotificationSerializer < ActiveModel::Serializer
  attribute :id
  attribute :is_viewed
  attribute :message
  attribute :source
  def source
    case source_type
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
