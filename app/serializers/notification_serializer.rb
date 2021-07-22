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
    current_user = instance_options[:current_user]
    case object.source_type
    when 'BreakingNews'
      BreakingNewsSerializer.new(object.source).as_json
    when 'ChatAudioRoom'
      ChatAudioRoomSerializer.new(object.source).as_json
    when 'ChatVideoRoom'
      ChatVideoRoomSerializer.new(object.source).as_json
    when 'ChatMessage'
      ChatMessageSerializer.new(object.source).as_json
    when 'Comment'
      CommentSerializer.new(object.source, current_user: current_user).as_json
    when 'Event'
      EventSerializer.new(object.source).as_json
    when 'Post'
      PostSerializer.new(object.source, current_user: current_user).as_json
    when 'UserImage'
      UserImageSerializer.new(object.source).as_json
    when 'UserVideo'
      UserVideoSerializer.new(object.source).as_json
    when 'SquadRequest'
      SquadRequestSerializer.new(object.source, current_user: current_user).as_json
    end
  end
  
  attribute :source_type
  def source_type
    object.source_type
  end
  
  attribute :user
  def user
    object.sender.present? ? UserProfileSerializer.new(object.sender).as_json : nil
  end
end
