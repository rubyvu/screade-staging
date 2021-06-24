class ChatMembership < ApplicationRecord
  
  ROLES_LIST = %w(owner admin user)
  
  # Callbacks
  before_validation :set_owner_role, on: :create
  after_update :update_owner_role
  before_destroy :is_membership_can_be_removed?
  after_destroy :remove_chat
  
  # Associations
  belongs_to :chat
  belongs_to :user
  
  # Associations validations
  validates :chat, presence: true
  validates :user, presence: true, uniqueness: { scope: [:chat_id, :user_id] }
  
  # Fields validations
  validates :role, presence: true, inclusion: { in: ChatMembership::ROLES_LIST }
  
  # Scopes
  scope :order_by_roles, -> (first = 'owner', second = 'admin', third = 'user') { order(Arel.sql("role = '#{first}' DESC, role = '#{second}' DESC, role = '#{third}' DESC")) }
  
  private
    def set_owner_role
      self.role = 'owner' if self.user == self.chat.owner
    end
    
    def update_owner_role
      return if !self.saved_change_to_role? || self.role != 'owner'
      
      old_chat_owner_membership = self.chat.get_membership(self.chat.owner)
      old_chat_owner_membership.update_columns(role: 'admin')
      self.chat.update_columns(owner_id: self.user.id)
    end
    
    def is_membership_can_be_removed?
      if self.role == 'owner' && self.chat.chat_memberships.count > 1
        errors.add(:base, 'You must assign a new Owner before leaving.')
        throw :abort
      end
    end
    
    def remove_chat
      self.chat.destroy if self.chat.chat_memberships.count == 0
    end
end
