# == Schema Information
#
# Table name: chat_audio_rooms
#
#  id                 :bigint           not null, primary key
#  name               :string           not null
#  participants_count :integer          default(0), not null
#  sid                :string           not null
#  status             :string           default("in-progress"), not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  chat_id            :integer          not null
#
# Indexes
#
#  index_chat_audio_rooms_on_chat_id  (chat_id)
#  index_chat_audio_rooms_on_name     (name) UNIQUE
#
class ChatAudioRoomSerializer < ActiveModel::Serializer
  attribute :chat_access_token
  def chat_access_token
    object.chat.access_token
  end
  
  attribute :chat_name
  def chat_name
    object.chat.name
  end
  
  attribute :id
  attribute :sid
  attribute :status
  attribute :name
  attribute :participants_count
end
