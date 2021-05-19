class Notification < ApplicationRecord
  
  # Constants
  SOURCE_TYPES = %w(Event Comment Post SquadRequest User)
  
  # Associations
  belongs_to :source, polymorphic: true
  belongs_to :user
  
  # Association validations
  validates :user, presence: true
  
  # Fields validation
  validates :message, presence: true
  validates :source_id, presence: true
  validates :source_type, presence: true, inclusion: { in: Notification::SOURCE_TYPES }
end
