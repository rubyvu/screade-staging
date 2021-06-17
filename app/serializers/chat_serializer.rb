class ChatSerializer < ActiveModel::Serializer
  attribute :access_token
  
  attribute :chat_memberships
  def chat_memberships
    ActiveModel::Serializer::CollectionSerializer.new(object.chat_memberships, serializer: ChatMembershipSerializer).as_json
  end
  
  attribute :created_at
  def created_at
    object.created_at.strftime('%Y-%m-%d %H:%M:%S %z')
  end
  
  attribute :icon
  def icon
    object&.icon&.rectangle_150_150&.url
  end
  
  attribute :last_message
  def last_message
    ChatMessageSerializer.new(object.chat_messages.last).as_json if object.chat_messages.present?
  end
  
  attribute :name
  attribute :owner
  def owner
    UserProfileSerializer.new(object.owner).as_json
  end
  
  attribute :updated_at
  def updated_at
    object.updated_at.strftime('%Y-%m-%d %H:%M:%S %z')
  end
end
