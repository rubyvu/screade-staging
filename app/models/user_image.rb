class UserImage < ApplicationRecord
  mount_uploader :file, UserImageUploader
  
  # Assosiation
  belongs_to :user
  
  # Association validation
  validates :user, presence: true
end
