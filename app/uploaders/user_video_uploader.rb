class UserVideoUploader < CarrierWave::Uploader::Base
  include CarrierWaveDirect::Uploader
  include CarrierWave::Video  # for your video processing
  include CarrierWave::Video::Thumbnailer
  
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
    UserVideo::VIDEO_RESOLUTIONS
  end
  
  def default_url
    ActionMailer::Base.asset_host + ActionController::Base.helpers.asset_pack_path('media/images/placeholders/placeholder-news.png')
  end
  
  version :thumb do
    process thumbnail: [{format: 'png', quality: 10, size: 192, strip: false, logger: Rails.logger}]
  
    def full_filename for_file
      png_name for_file, version_name
    end
    
    def png_name for_file, version_name
      %Q{#{version_name}_#{for_file.chomp(File.extname(for_file))}.png}
    end
  end
  
  protected
    def secure_token(length)
      model.file_hex ||= SecureRandom.hex(length)
    end
    
    def reset_secure_token(file)
      model.file_hex = nil
    end
end
