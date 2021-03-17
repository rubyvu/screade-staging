class UserImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include CarrierWaveDirect::Uploader
  
  # Callbacks
  before :cache, :reset_secure_token
  
  def initialize(*)
    super
    self.allowed_content_types = %w(image/jpeg image/jpg image/png)
  end
  
  def filename
    "#{secure_token(8)}-image.#{file.extension}" if original_filename
  end
  
  def extension_allowlist
    UserImage::IMAGE_RESOLUTIONS
  end
  
  def default_url
    ActionMailer::Base.asset_host + ActionController::Base.helpers.asset_pack_path('media/images/placeholders/placeholder-news.png')
  end
  
  version :rectangle_160_160 do
    process resize_to_fill: [160, 160]
  end
  
  version :rectangle_1024_768 do
    process resize_to_fill: [1024, 768]
  end
  
  protected
    def secure_token(length)
      model.file_hex ||= SecureRandom.hex(length)
    end
    
    def reset_secure_token(file)
      model.file_hex = nil
    end
end
