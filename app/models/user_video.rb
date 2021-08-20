class UserVideo < ApplicationRecord
  has_one_attached :file
  
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
  
  def file_url
    self.file.url if self.file.attached?
  end
  
  def file_thumbnail_url
    self.file.preview(resize_to_limit: [300, 300]).processed if self.file.attached?
  end
  
  private
    def add_notification
      return if self.is_private
      CreateNewNotificationsJob.perform_later(self.id, self.class.name)
    end
end
