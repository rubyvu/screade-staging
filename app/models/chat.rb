class Chat < ApplicationRecord
  
  # File Uploader
  mount_uploader :icon, ChatIconUploader
  
  # Associations
  has_many :chat_memberships, dependent: :destroy
  
  def owner
    self.chat_memberships.find_by(role: 'owner')
  end
  
  def admins
    self.chat_memberships.where(role: 'admin')
  end
end
