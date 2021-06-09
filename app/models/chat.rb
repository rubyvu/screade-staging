class Chat < ApplicationRecord
  
  # File Uploader
  mount_uploader :icon, ChatIconUploader
  
  # Callbacks
  before_validation :generate_access_token, on: :create
  before_validation :set_default_chat_name, on: :create
  after_commit :update_chat_name, on: :create
  
  # Associations
  has_many :chat_memberships, dependent: :destroy
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  has_many :chat_messages, dependent: :destroy
  
  # Association validations
  validates :owner, presence: true
  
  def admins
    User.where(id: self.chat_memberships.where(role: 'admin').pluck(:user_id))
  end
  
  def get_membership(user)
    self.chat_memberships.find_by(user: user)
  end
  
  private
    def set_default_chat_name
      self.name = owner.full_name if self.name.blank? && owner.present?
    end
    
    def update_chat_name
      # Set Chat name according to ChatMembers - Users full_name
      name = User.where(id: self.chat_memberships.pluck(:user_id)).map { |user| user.full_name }.join(', ')
      self.update_columns(name: name)
    end
    
    def generate_access_token
      new_token = SecureRandom.hex(16)
      Chat.exists?(access_token: new_token) ? generate_access_token : self.access_token = new_token
    end
end
