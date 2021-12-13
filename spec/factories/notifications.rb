# == Schema Information
#
# Table name: notifications
#
#  id           :bigint           not null, primary key
#  is_shared    :boolean          default(FALSE)
#  is_viewed    :boolean          default(FALSE)
#  message      :string           not null
#  source_type  :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  recipient_id :integer          not null
#  sender_id    :integer
#  source_id    :integer          not null
#
# Indexes
#
#  index_notifications_on_recipient_id  (recipient_id)
#
FactoryBot.define do
  factory :notification do
    is_viewed { false }
  end
end
