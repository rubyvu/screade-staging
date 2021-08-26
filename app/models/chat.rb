class Chat < ApplicationRecord
  
  # File Uploader
  has_one_attached :icon
  
  # Callbacks
  before_validation :generate_access_token, on: :create
  before_validation :set_default_chat_name, on: :create
  after_update :broadcast_chat_state
  after_commit :broadcast_new_user_chat, on: :create
  after_commit :update_chat_name, on: :create
  
  # Associations
  has_many :chat_memberships, dependent: :destroy
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  has_many :chat_messages, dependent: :destroy
  has_many :chat_audio_rooms, dependent: :destroy
  has_many :chat_video_rooms, dependent: :destroy
  
  # Association validations
  validates :owner, presence: true
  
  def admins
    User.where(id: self.chat_memberships.where(role: 'admin').pluck(:user_id))
  end
  
  def get_membership(user)
    self.chat_memberships.find_by(user: user)
  end
  
  def last_message
    self.chat_messages.order(id: :desc).first
  end
  
  def icon_url
    self.icon.url if self.icon.attached?
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
    
    # Broadcast Chat State
    def broadcast_chat_state
      render_chat_state_template = ApplicationController.renderer.render(partial: 'chats/chats_list/chat_object', locals: { chat: self, is_message_counter: false })
      self.chat_memberships.each do |chat_membership|
        ActionCable.server.broadcast "#{chat_membership.user.username}_chat_state_channel", chat_json: ChatSerializer.new(self).as_json, chat_html: render_chat_state_template
      end
    end
    
    def broadcast_new_user_chat
      render_chat_state_template = ApplicationController.renderer.render(partial: 'chats/chats_list/chat_object', locals: { chat: self, is_message_counter: false })
      
      self.chat_memberships.each do |chat_membership|
        ActionCable.server.broadcast "new_#{chat_membership.user.username}_chat_channel", chat_json: ChatSerializer.new(self).as_json, chat_html: render_chat_state_template
      end
    end
end
