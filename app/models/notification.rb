class Notification < ApplicationRecord
  
  # Constants
  SOURCE_TYPES = %w(Comment Event Post SquadRequest UserImage UserVideo)
  
  # Callbacks
  after_create :send_push_notification_to_user_devices
  
  # Associations
  belongs_to :source, polymorphic: true
  belongs_to :sender, class_name: 'User', foreign_key: :sender_id, optional: true
  belongs_to :recipient, class_name: 'User', foreign_key: :recipient_id
  
  # Association validations
  validates :recipient, presence: true
  
  # Fields validation
  validates :message, presence: true
  validates :source_id, presence: true
  validates :source_type, presence: true, inclusion: { in: Notification::SOURCE_TYPES }
  
  # Scopes
  scope :unviewed, -> { where(is_viewed: false) }
  
  private
    def send_push_notification_to_user_devices
      
    end
end
