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
