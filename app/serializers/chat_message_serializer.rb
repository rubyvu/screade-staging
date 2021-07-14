class ChatMessageSerializer < ActiveModel::Serializer
  attribute :created_at
  def created_at
    object.created_at.strftime('%Y-%m-%d %H:%M:%S %z')
  end
  
  attribute :id
  attribute :message_type
  attribute :message_content
  def message_content
    case object.message_type
    when 'image'
      if object.image.present?
        object.image.url
      elsif object.asset_source.present?
        object.asset_source.file.url
      else
        nil
      end
    when 'video'
      if object.video.present?
        object.video.url
      elsif object.asset_source.present?
        object.asset_source.file.url
      else
        nil
      end
    when 'text'
      object.text
    when 'audio'
      object.audio_record.url
    when 'video-room'
      ChatVideoRoomSerializer.new(object.chat_room_source).as_json
    end
  end
  
  attribute :user
  def user
    UserProfileSerializer.new(object.user).as_json
  end
end
