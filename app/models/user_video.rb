class UserVideo < ApplicationRecord
  mount_uploader :file, UserVideoUploader
  
  # Constants
  VIDEO_RESOLUTIONS = %w(mp4)
  
  # Callbacks
  after_save :add_notification
  
  # Assosiation
  belongs_to :user
  # Notifications
  has_many :notifications, as: :source, dependent: :destroy
  
  # Association validation
  validates :user, presence: true
  
  private
    def add_notification
      return if self.is_private
      CreateNewNotificationsJob.perform_later(self.id, self.class.name)
    end
end
