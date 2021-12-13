# == Schema Information
#
# Table name: chats
#
#  id           :bigint           not null, primary key
#  access_token :string           not null
#  name         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  owner_id     :integer          not null
#
# Indexes
#
#  index_chats_on_access_token  (access_token) UNIQUE
#  index_chats_on_owner_id      (owner_id)
#
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
    object&.icon_url
  end
  
  attribute :last_message
  def last_message
    ChatMessageSerializer.new(object.last_message).as_json if object.chat_messages.present?
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
