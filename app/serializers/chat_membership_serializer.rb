class ChatMembershipSerializer < ActiveModel::Serializer
    
  attribute :id
  attribute :role
  attribute :user
  def user
    UserProfileSerializer.new(object.user).as_json
  end
end
