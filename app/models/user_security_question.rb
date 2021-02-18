class UserSecurityQuestion < ApplicationRecord
  # Associations
  has_many :users
  
  # Fields validations
  validates :title, presence: true
  validates :question_identifier, presence: true, uniqueness: true
end
