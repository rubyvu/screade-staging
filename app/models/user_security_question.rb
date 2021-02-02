class UserSecurityQuestion < ApplicationRecord
  # Fields validations
  validates :title, presence: true
  validates :question_identifier, presence: true, uniqueness: true
end
