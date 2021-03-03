class UserImageUploader < CarrierWave::Uploader::Base
  include CarrierWaveDirect::Uploader
  
  # Callbacks
  before :cache, :reset_secure_token
  
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  
  def filename
    "#{secure_token(8)}-image.#{file.extension}" if original_filename
  end
  
  def extension_white_list
    %w(jpg jpeg png)
  end
  
  version :square_160 do
    process resize_to_fill: [160, 160]
  end
  
  version :square_320 do
    process resize_to_fill: [320, 320]
  end
  
  protected
    def secure_token(length)
      model.asset_hex ||= SecureRandom.hex(length)
    end
    
    def reset_secure_token(file)
      model.asset_hex = nil
    end
end
