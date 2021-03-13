class UserImage < ApplicationRecord
  mount_uploader :file, UserImageUploader
  
  # Constants
  IMAGE_RESOLUTIONS = %w(png jpeg jpg)
  
  # Assosiation
  belongs_to :user
  
  # Association validation
  validates :user, presence: true
end
