class Event < ApplicationRecord
  
  # Associations
  belongs_to :user
  
  # Association validation
  validates :user, presence: true
  
  # Field validations
  validates :date, presence: true
  validates :end_date, presence: true
  validates :start_date, presence: true
  validates :title, presence: true
end
