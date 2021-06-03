class ChatMembershipSerializer < ActiveModel::Serializer
  
  attribute :chat
  def chat
    ChatSerializer.new(object.chat).as_json
  end
  
  attribute :id
  attribute :role
  attribute :user
  def user
    UserProfileSerializer.new(object.user).as_json
  end
end
