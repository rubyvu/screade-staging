# == Schema Information
#
# Table name: user_locations
#
#  id         :bigint           not null, primary key
#  latitude   :decimal(10, 6)   not null
#  longitude  :decimal(10, 6)   not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_user_locations_on_user_id  (user_id)
#
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
