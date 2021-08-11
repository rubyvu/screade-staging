class StreamVideoUploader < CarrierWave::Uploader::Base
  include CarrierWave::Video  # for your video processing
  
  # Callbacks
  before :cache, :reset_secure_token
  after :store, :finish_stream
  
  def initialize(*)
    super
    self.allowed_content_types = %w(video/mp4)
  end
  
  def filename
    "#{secure_token(8)}-video.#{file.extension}" if original_filename
  end
  
  def extension_allowlist
    Stream::VIDEO_RESOLUTIONS
  end
  
  protected
    def secure_token(length)
      model.video_hex ||= SecureRandom.hex(length)
    end
    
    def reset_secure_token(file)
      model.video_hex = nil
    end
    
    def finish_stream(file)
      return if model.status != 'completed'
      model.update(status: 'finished')
    end
end
