# == Schema Information
#
# Table name: chat_messages
#
#  id                    :bigint           not null, primary key
#  asset_source_type     :string
#  chat_room_source_type :string
#  message_type          :string           not null
#  text                  :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  asset_source_id       :integer
#  chat_id               :integer          not null
#  chat_room_source_id   :integer
#  user_id               :integer          not null
#
# Indexes
#
#  index_chat_messages_on_chat_id       (chat_id)
#  index_chat_messages_on_message_type  (message_type)
#  index_chat_messages_on_user_id       (user_id)
#
FactoryBot.define do
  factory :chat_message do
    message_type { 'text' }
  end
end
