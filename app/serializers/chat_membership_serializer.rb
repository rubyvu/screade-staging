class ChatMembershipSerializer < ActiveModel::Serializer
    
  attribute :id
  attribute :is_mute
  attribute :role
  attribute :unread_messages_count
  attribute :user
  def user
    UserProfileSerializer.new(object.user).as_json
  end
end
