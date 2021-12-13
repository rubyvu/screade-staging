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
FactoryBot.define do
  factory :chat_membership do
    role { 'user' }
  end
end
