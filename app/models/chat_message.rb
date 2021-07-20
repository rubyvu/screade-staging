class ChatMessage < ApplicationRecord
  
  # Constants
  TYPES_LIST = %w(image video text audio audio-room video-room audio-room)
  SOURCE_TYPES = %w(UserVideo UserImage)
  ROOM_SOURCE_TYPES = %w(ChatVideoRoom ChatAudioRoom)
  
  # File Uploader
  mount_uploader :image, ChatImageUploader
  mount_uploader :video, ChatVideoUploader
  mount_uploader :audio_record, ChatAudioUploader
  
  # Callbacks
  after_validation :increase_unread_messages_counter, on: :create
  after_commit :upload_asset, on: :create
  after_commit :broadcast_chat_message, on: :create
  after_commit :broadcast_chat_state, on: :create
  
  # Associations
  belongs_to :chat
  belongs_to :chat_room_source, polymorphic: true, optional: true
  belongs_to :user
  belongs_to :asset_source, polymorphic: true, optional: true
  
  # Associations validations
  validates :chat, presence: true
  validates :user, presence: true
  
  # Fields validations
  validates :message_type, presence: true, inclusion: { in: ChatMessage::TYPES_LIST }
  validate :type_content_is_present
  validate :chat_membership
  
  private
    # Validations
    def type_content_is_present
      return if (self.message_type == 'image' && self.asset_source.present?) || (self.message_type == 'video' && self.asset_source.present?) || (self.message_type == 'text' && self.text.present?) || (self.message_type == 'audio' && self.audio_record.present?)
      return if (self.message_type == 'audio-room' && self.chat_room_source.present?) || (self.message_type == 'video-room' && self.chat_room_source.present?)
      errors.add(:base, 'Message type should be present.')
    end
    
    def chat_membership
      return if ChatMembership.find_by(user: self.user, chat: self.chat)
      errors.add(:base, 'You are not a member of this Chat')
    end
    
    def increase_unread_messages_counter
      # Set unread messages counter
      self.chat.chat_memberships.where.not(user: self.user).each do |chat_membership|
        chat_membership.update_columns(unread_messages_count: chat_membership.unread_messages_count+1)
      end
    end
    
    # Calbacks
    def upload_asset
      return if ['image', 'video'].exclude?(self.message_type) || (self.message_type == 'image' && self.image.present?) || (self.message_type == 'video' && self.video.present?)
      UploadChatMessageAssetJob.perform_later(self.id)
    end
    
    def broadcast_chat_message
      # Broadcast message
      return if message_type == 'audio' # Audio saved on Carrierwave uploader. Bug https://github.com/carrierwaveuploader/carrierwave-mongoid/issues/129
      
      render_message_template = ApplicationController.renderer.render(partial: 'chat_messages/message_to_broadcast', locals: { chat_message: self })
      ActionCable.server.broadcast "chat_#{self.chat.access_token}_channel", chat_message_json: ChatMessageSerializer.new(self).as_json, chat_message_html: render_message_template
    end
    
    def broadcast_chat_state
      render_chat_state_template = ApplicationController.renderer.render(partial: 'chats/chats_list/chat_object', locals: { chat: self.chat, is_message_counter: false })
      
      self.chat.chat_memberships.each do |chat_membership|
        ActionCable.server.broadcast "#{chat_membership.user.username}_chat_state_channel", chat_json: ChatSerializer.new(self.chat).as_json, chat_html: render_chat_state_template
      end
    end
end
