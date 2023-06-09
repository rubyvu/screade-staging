# == Schema Information
#
# Table name: user_videos
#
#  id         :bigint           not null, primary key
#  is_private :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null
#
class UserVideo < ApplicationRecord
  has_one_attached :file
  
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
    (self.file.attached? && self.file.previewable?) ? self.file.preview(resize_to_limit: [300, 300]).processed.url : nil
  end
  
  private
    def add_notification
      return if self.is_private
      CreateNewNotificationJob.perform_later(self.id, self.class.name)
    end
end
