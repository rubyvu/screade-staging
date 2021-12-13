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
FactoryBot.define do
  factory :chat do
  end
end
