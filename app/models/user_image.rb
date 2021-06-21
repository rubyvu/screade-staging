class UserImage < ApplicationRecord
  mount_uploader :file, UserImageUploader
  
  # Constants
  IMAGE_RESOLUTIONS = %w(png jpeg jpg)
  
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
