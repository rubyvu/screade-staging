class StreamVideoUploader < CarrierWave::Uploader::Base
  include CarrierWaveDirect::Uploader
  include CarrierWave::Video  # for your video processing
  
  # Callbacks
  before :cache, :reset_secure_token
  
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
  
  def default_url
    ActionController::Base.helpers.asset_pack_path('media/images/placeholders/placeholder-main.png')
  end
  
  protected
    def secure_token(length)
      model.video_hex ||= SecureRandom.hex(length)
    end
    
    def reset_secure_token(video)
      model.video_hex = nil
    end
end
