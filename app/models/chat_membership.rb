# == Schema Information
#
# Table name: chat_memberships
#
#  id                    :bigint           not null, primary key
#  is_mute               :boolean          default(FALSE), not null
#  role                  :string           default("user"), not null
#  unread_messages_count :integer          default(0), not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  chat_id               :integer          not null
#  user_id               :integer          not null
#
# Indexes
#
#  index_chat_memberships_on_chat_id  (chat_id)
#  index_chat_memberships_on_user_id  (user_id)
#
class ChatMembership < ApplicationRecord
  
  ROLES_LIST = %w(owner admin user)
  
  # Callbacks
  before_validation :set_owner_role, on: :create
  after_update :update_owner_role
  before_destroy :can_membership_be_removed?
  after_destroy :remove_chat
  after_commit :add_notification, on: :create
  
  # Associations
  belongs_to :chat
  belongs_to :user
  has_many :notifications, as: :source, dependent: :destroy
  
  # Associations validations
  validates :user_id, uniqueness: { scope: :chat_id }
  
  # Fields validations
  validates :role, presence: true, inclusion: { in: ChatMembership::ROLES_LIST }
  
  # Scopes
  scope :order_by_roles, -> (first = 'owner', second = 'admin', third = 'user') { order(Arel.sql("role = '#{first}' DESC, role = '#{second}' DESC, role = '#{third}' DESC")) }
  
  private
    def set_owner_role
      return if self.chat.blank?
      self.role = 'owner' if self.user == self.chat.owner
    end
    
    def update_owner_role
      return if !self.saved_change_to_role? || self.role != 'owner'
      
      old_chat_owner_membership = self.chat.get_membership(self.chat.owner)
      old_chat_owner_membership.update_columns(role: 'admin')
      self.chat.update_columns(owner_id: self.user.id)
    end
    
    def can_membership_be_removed?
      return if self.chat.is_destroying
      
      if self.role == 'owner' && self.chat.chat_memberships.count > 1
        errors.add(:base, 'You must assign a new Owner before leaving.')
        throw :abort
      end
    end
    
    def remove_chat
      self.chat.destroy if self.chat.chat_memberships.count == 0
    end
    
    def add_notification
      return if self.chat.owner == self.user
      CreateNewNotificationJob.perform_later(self.id, self.class.name)
    end
end
