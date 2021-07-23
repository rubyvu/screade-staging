class ChatAudioRoom < ApplicationRecord
  
  # Constants
  STATUS_LIST = %w(in-progress completed)
  
  # Callbacks
  before_validation :set_chat_name, on: :create
  before_validation :create_twilio_room, on: :create
  after_update :broadcast_room_state
  after_update :broadcast_chat_state
  after_commit :create_chat_message, on: :create
  after_commit :add_notification, on: :create
  
  # Associations
  has_one :chat_message, as: :chat_room_source
  has_many :notifications, as: :source, dependent: :destroy
  belongs_to :chat
  
  # Associations validations
  validates :chat, presence: true
  
  # Fields validations
  validates :name, presence: true
  validates :participants_count, presence: true
  validates :status, presence: true, inclusion: { in: ChatAudioRoom::STATUS_LIST }
  validates :sid, presence: true
  validate :only_one_active_room, on: :create
  
  def participants
    Tasks::TwilioTask.retrieve_list_of_connected_participants(self.sid)
  end
  
  private
    def add_notification
      CreateNewNotificationsJob.perform_later(self.id, self.class.name)
    end
    
    def set_chat_name
      unique_name = "audio-#{self.chat.access_token}-#{SecureRandom.hex(8)}"
      ChatAudioRoom.exists?(name: unique_name) ? set_chat_name : self.name = unique_name
    end
    
    def create_twilio_room
      self.sid = Tasks::TwilioTask.create_new_room(self.name)
    end
    
    def create_chat_message
      ChatMessage.create(chat: self.chat, chat_room_source: self, user: self.chat.owner, message_type: 'audio-room')
    end
    
    def only_one_active_room
      self.errors.add(:base, 'Only one room can be active at a time') if self.chat.chat_audio_rooms.exists?(status: 'in-progress')
    end
    
    def broadcast_room_state
      render_message_template = ApplicationController.renderer.render(partial: 'chat_messages/message_to_broadcast', locals: { chat_message: self.chat_message })
      ActionCable.server.broadcast "twilio_room_#{self.chat.access_token}_state_chanel", chat_message_json: ChatMessageSerializer.new(self.chat_message).as_json, chat_message_html: render_message_template
    end
    
    def broadcast_chat_state
      return unless self.status == 'completed'
      render_chat_state_template = ApplicationController.renderer.render(partial: 'chats/chats_list/chat_object', locals: { chat: self.chat, is_message_counter: false })
      self.chat.chat_memberships.each do |chat_membership|
        ActionCable.server.broadcast "#{chat_membership.user.username}_chat_state_channel", chat_json: ChatSerializer.new(self.chat).as_json, chat_html: render_chat_state_template
      end
    end
end
