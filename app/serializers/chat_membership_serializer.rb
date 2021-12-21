# == Schema Information
#
# Table name: chat_memberships
#
#  id                    :bigint           not null, primary key
#  is_mute               :boolean          default(FALSE), not null
#  role                  :string           default("user"), not null
#  unread_messages_count :integer          default(0), not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  chat_id               :integer          not null
#  user_id               :integer          not null
#
# Indexes
#
#  index_chat_memberships_on_chat_id  (chat_id)
#  index_chat_memberships_on_user_id  (user_id)
#
class ChatMembershipSerializer < ActiveModel::Serializer
  attribute :chat_access_token
  def chat_access_token
    object.chat.access_token
  end
  
  attribute :chat_name
  def chat_name
    object.chat.name
  end
  
  attribute :id
  attribute :is_mute
  attribute :role
  attribute :unread_messages_count
  
  attribute :user
  def user
    current_user = instance_options[:current_user]
    UserProfileSerializer.new(object.user, current_user: current_user).as_json
  end
end
