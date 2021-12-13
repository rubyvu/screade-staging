# == Schema Information
#
# Table name: chat_messages
#
#  id                    :bigint           not null, primary key
#  asset_source_type     :string
#  chat_room_source_type :string
#  message_type          :string           not null
#  text                  :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  asset_source_id       :integer
#  chat_id               :integer          not null
#  chat_room_source_id   :integer
#  user_id               :integer          not null
#
# Indexes
#
#  index_chat_messages_on_chat_id       (chat_id)
#  index_chat_messages_on_message_type  (message_type)
#  index_chat_messages_on_user_id       (user_id)
#
class ChatMessageSerializer < ActiveModel::Serializer
  attribute :chat_access_token
  def chat_access_token
    object.chat.access_token
  end
  
  attribute :chat_name
  def chat_name
    object.chat.name
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
