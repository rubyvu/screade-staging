# == Schema Information
#
# Table name: devices
#
#  id                 :bigint           not null, primary key
#  access_token       :string           not null
#  name               :string
#  operational_system :string           not null
#  push_token         :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  owner_id           :integer          not null
#
# Indexes
#
#  index_devices_on_access_token  (access_token) UNIQUE
#  index_devices_on_owner_id      (owner_id)
#  index_devices_on_push_token    (push_token)
#
class Device < ApplicationRecord
  # Constants
  OPERATIONAL_SYSTEMS = ['iOS', 'Android']
  
  # Callbacks
  before_validation :generate_access_token, on: :create
  after_commit :remove_push_token_from_others, on: [:create, :update]
  
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
    
    def remove_push_token_from_others
      return unless self.push_token
      
      Device.where(push_token: self.push_token).where.not(id: self.id).update_all(push_token: nil)
    end
end
