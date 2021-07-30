class ChatAudioUploader < CarrierWave::Uploader::Base
  # Callbacks
  before :cache, :reset_secure_token
  after :store, :broadcast_chat_message
  
  # Storage
  storage :fog
  
  # Override fog params for using public bucket
  def initialize(*)
    super
    self.fog_directory = ENV['AWS_S3_PUBLIC_BUCKET']
    self.fog_public    = true
  end
  
  def store_dir
    "uploads/#{model.class.to_s.underscore.pluralize}/#{model.id}/#{mounted_as}"
  end
  
  def filename
    "#{secure_token(8)}-image.#{file.extension}" if original_filename
  end
  
  def extension_white_list
    %w()
  end
  
  protected
    def secure_token(length)
      model.audio_record_hex ||= SecureRandom.hex(length)
    end
    
    def reset_secure_token(file)
      model.audio_record_hex = nil
    end
    
    def broadcast_chat_message(file)
      render_message_template = ApplicationController.renderer.render(partial: 'chat_messages/message_to_broadcast', locals: { chat_message: model })
      model.chat.chat_memberships.each do |chat_membership|
        ActionCable.server.broadcast "chat_#{model.chat.access_token}_#{chat_membership.user.username}_channel", chat_message_json: ChatMessageSerializer.new(model).as_json, chat_message_html: render_message_template
      end
    end
end
