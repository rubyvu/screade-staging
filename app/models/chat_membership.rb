class ChatMembership < ApplicationRecord
  
  ROLES_LIST = %w(owner admin user)
  
  # Callbacks
  before_validation :set_owner_role
  before_destroy :is_membership_can_be_removed?
  
  # Associations
  belongs_to :chat
  belongs_to :user
  
  # Associations validations
  validates :chat, presence: true
  validates :user, presence: true, uniqueness: { scope: [:chat_id, :user_id] }
  
  # Fields validations
  validates :role, presence: true, inclusion: { in: ChatMembership::ROLES_LIST }
  
  private
    def set_owner_role
      return if self.chat.blank? || self.chat.chat_memberships.count > 0
      self.role = 'owner'
    end
    
    def is_membership_can_be_removed?
      if self.role == 'owner' && self.chat.chat_memberships.count > 1
        errors.add(:base, 'Нou must transfer your role before leaving')
        throw :abort
      end
    end
end
