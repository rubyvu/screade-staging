class ChatAudioRoomSerializer < ActiveModel::Serializer
  attribute :id
  attribute :chat_access_token
  def chat_access_token
    object.chat.access_token
  end
  
  attribute :sid
  attribute :status
  attribute :name
  attribute :participants_count
end
