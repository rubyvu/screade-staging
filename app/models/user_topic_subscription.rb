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
