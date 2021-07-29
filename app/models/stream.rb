class Stream < ApplicationRecord
  
  # Callbacks
  # after_save :add_notification
  
  # File Uploader
  mount_uploader :image, StreamImageUploader
  
  # Associations
  belongs_to :user
  
  ## Comments
  has_many :stream_comments, dependent: :destroy
  has_many :commenting_users, through: :stream_comments, source: :user
  ## Lits
  has_many :lits, as: :source, dependent: :destroy
  has_many :liting_users, through: :lits, source: :user
  ## Views
  has_many :views, as: :source, dependent: :destroy
  has_many :viewing_users, through: :views, source: :user
  # Notifications
  # has_many :notifications, as: :source, dependent: :destroy
  
  # Association validations
  validates :user, presence: true
  
  # Fields validations
  validates :title, presence: true
  
  def is_lited(user)
    user.present? && self.liting_users.include?(user)
  end
  
  def is_commented(user)
    user.present? && self.commenting_users.include?(user)
  end
  
  def is_viewed(user)
    user.present? && self.viewing_users.include?(user)
  end
  
  private
    def add_notification
      return if !self.is_approved || Notification.where(source_id: self.id, source_type: 'Post', sender: self.user).present? || !self.is_notification
      CreateNewNotificationsJob.perform_later(self.id, self.class.name)
    end
end
