class Device < ApplicationRecord
  # Constants
  OPERATIONAL_SYSTEMS = ['iOS', 'Android']
  
  # Callbacks
  before_validation :generate_access_token, on: :create
  
  # Associations
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  
  # Associations validations
  validates :owner, presence: true
  
  # Fields validations
  validates :access_token, presence: true, uniqueness: true
  validates :name, presence: true
  validates :operational_system, presence: true, inclusion: { in: Device::OPERATIONAL_SYSTEMS }
  
  private
    def generate_access_token
      new_token = SecureRandom.hex(16)
      Device.exists?(access_token: new_token) ? generate_access_token : self.access_token = new_token
    end
end
