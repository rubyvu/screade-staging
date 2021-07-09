class ChatVideoRoom < ApplicationRecord
  
  # Constants
  STATUS_LIST = %w(in-progress completed)
  
  # Callbacks
  before_validation :set_chat_name, on: :create
  before_validation :create_twilio_room, on: :create
  after_commit :create_chat_message, on: :create
  
  # Associations
  has_one :chat_message
  belongs_to :chat
  
  # Associations validations
  validates :chat, presence: true
  
  # Fields validations
  validates :name, presence: true
  validates :status, presence: true, inclusion: { in: ChatVideoRoom::STATUS_LIST }
  validates :sid, presence: true
  validate :only_one_active_room, on: :create
  
  def participants
    Tasks::TwilioTask.retrieve_list_of_connected_participants(self.sid)
  end
  
  private
    def set_chat_name
      unique_name = "video-#{self.chat.access_token}-#{SecureRandom.hex(8)}"
      ChatVideoRoom.exists?(name: unique_name) ? set_chat_name : self.name = unique_name
    end
    
    def create_twilio_room
      self.sid = Tasks::TwilioTask.create_new_room(self.name)
    end
    
    def create_chat_message
      ChatMessage.create(chat: self.chat, chat_room_source: self, user: self.chat.owner, message_type: 'video-room')
    end
    
    def only_one_active_room
      self.errors.add(:base, 'Only one room can be active at a time') if self.chat.chat_video_rooms.exists?(status: 'in-progress')
    end
end
