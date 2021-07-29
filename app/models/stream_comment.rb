class StreamComment < ApplicationRecord
  
  # Associations
  belongs_to :stream
  belongs_to :user
  
  # Associations validations
  validates :stream, presence: true
  validates :user, presence: true
  
  # Field validations
  validates :message, presence: true
end
