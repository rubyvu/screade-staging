class UserVideo < ApplicationRecord
  mount_uploader :file, UserVideoUploader
  
  # Assosiation
  belongs_to :user
  
  # Association validation
  validates :user, presence: true
end
