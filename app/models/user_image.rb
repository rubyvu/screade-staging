class UserImage < ApplicationRecord
  has_one_attached :file
  
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
  
  def file_url
    self.file.url if self.file.attached?
  end
  
  def file_160_160_url
    self.file.representation(resize_to_limit: [160, 160]).processed.url if self.file.attached?
  end
  
  def file_1024_768_url
    self.file.representation(resize_to_limit: [1024, 768]).processed.url if self.file.attached?
  end
  
  private
    def add_notification
      return if self.is_private
      CreateNewNotificationJob.perform_later(self.id, self.class.name)
    end
end
