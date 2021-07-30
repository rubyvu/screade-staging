class Notification < ApplicationRecord
  
  # Constants
  SOURCE_TYPES = %w(BreakingNews ChatMessage ChatVideoRoom ChatAudioRoom Comment Event Post SquadRequest UserImage UserVideo)
  
  # Callbacks
  after_create :send_email_notification
  after_create :send_push_notification
  
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
  
  def is_user_type?
    ['SquadRequest', 'UserImage', 'UserVideo'].include?(self.source_type)
  end
  
  private
    def send_email_notification
      return unless recipient.setting.is_email
      SendNotificationEmailJob.perform_later(self.id)
    end
    
    def send_push_notification
      return unless recipient.setting.is_notification
      SendDefaultPushNotificationJob.perform_later(self.id)
    end
end
