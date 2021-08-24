class ChatMessageSerializer < ActiveModel::Serializer
  attribute :chat_access_token
  def chat_access_token
    object.chat.access_token
  end
  
  attribute :created_at
  def created_at
    object.created_at.strftime('%Y-%m-%d %H:%M:%S %z')
  end
  
  attribute :unix_created_at
  def unix_created_at
    object.created_at.in_time_zone('UTC').to_i
  end
  
  attribute :id
  attribute :message_type
  attribute :message_content
  def message_content
    case object.message_type
    when 'image'
      if object.image.present?
        object.image_url
      elsif object.asset_source.present?
        object.asset_source&.file_url
      else
        nil
      end
    when 'video'
      if object.video.present?
        object.video_url
      elsif object.asset_source.present?
        object.asset_source&.file_url
      else
        nil
      end
    when 'text'
      object.text
    when 'audio'
      object.audio_record_url
    when 'video-room'
      ChatVideoRoomSerializer.new(object.chat_room_source).as_json
    when 'audio-room'
      ChatAudioRoomSerializer.new(object.chat_room_source).as_json
    end
  end
  
  attribute :user
  def user
    UserProfileSerializer.new(object.user).as_json
  end
end
