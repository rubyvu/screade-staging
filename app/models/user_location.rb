class UserLocation < ApplicationRecord
  
  # Associations
  belongs_to :user
  
  # Associations validations
  validates :user, presence: true
  
  # Field validations
  validates :latitude, presence: true
  validates :longitude, presence: true
  
  def self.get_location(user)
    user_location = UserLocation.find_by(user: user)
  end
end
