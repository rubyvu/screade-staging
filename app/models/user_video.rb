class UserVideo < ApplicationRecord
  mount_uploader :file, UserVideoUploader
  
  # Constants
  VIDEO_RESOLUTIONS = %w(mp4)
  
  # Assosiation
  belongs_to :user
  
  # Association validation
  validates :user, presence: true
end
