# == Schema Information
#
# Table name: user_topic_subscriptions
#
#  id          :bigint           not null, primary key
#  source_type :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  source_id   :integer          not null
#  user_id     :integer          not null
#
# Indexes
#
#  index_user_topic_subscriptions_on_user_and_source  (user_id,source_id,source_type) UNIQUE
#
class UserTopicSubscription < ApplicationRecord
  
  SOURCE_TYPES = %w(NewsCategory Topic)
  
  # Associations
  belongs_to :source, polymorphic: true
  belongs_to :user
  
  # Field validations
  validates :source_id, presence: true, uniqueness: { scope: [:source_type, :user_id] }
  validates :source_type, presence: true, inclusion: { in: UserTopicSubscription::SOURCE_TYPES }
  validates :user_id, presence: true, uniqueness: { scope: [:source_type, :source_id] }
end
