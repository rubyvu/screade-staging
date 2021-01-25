class UserSecurityQuestion < ApplicationRecord
  # Fields validations
  validates :title, presence: true, uniqueness: true
end
