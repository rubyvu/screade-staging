class ChatSerializer < ActiveModel::Serializer
  attribute :access_token
  attribute :created_at
  def created_at
    object.created_at.strftime('%Y-%m-%d %H:%M:%S %z')
  end
  
  attribute :icon
  def icon
    object&.icon&.rectangle_150_150&.url
  end
  
  attribute :name
  attribute :owner
  def owner
    UserProfileSerializer.new(object.owner).as_json
  end
  
  def chat_memberships
    ActiveModel::Serializer::CollectionSerializer.new(object.chat_memberships, serializer: ChatMembershipSerializer).as_json
  end
end
