class ChatMessage < ApplicationRecord
  
  # Constants
  TYPES_LIST = %w(image video text audio)
  
  # File Uploader
  mount_uploader :image, ChatImageUploader
  mount_uploader :video, ChatVideoUploader
  mount_uploader :audio_record, ChatAudioUploader
  
  # Callbacks
  
  # Associations
  belongs_to :chat
  belongs_to :user
  
  # Associations validations
  validates :chat, presence: true
  validates :user, presence: true
  
  # Fields validations
  validates :type, presence: true, inclusion: { in: ChatMessage::TYPES_LIST }
  validate :type_content_is_present
  
  private
    def type_content_is_present
      return if (self.type == 'image' && self.image.present?) || (self.type == 'video' && self.video.present?) || (self.type == 'text' && self.text.present?) || (self.type == 'audio' && self.audio_record.present?)
      errors.add(:base, 'One of 4 types should be present.')
    end
end
