class UserImageUploader < CarrierWave::Uploader::Base
  include CarrierWaveDirect::Uploader
  
  # Callbacks
  before :cache, :reset_secure_token
  
  def filename
    "#{secure_token(8)}-image.#{file.extension}" if original_filename
  end
  
  def extension_white_list
    %w(jpg jpeg png)
  end
  
  protected
    def secure_token(length)
      model.asset_hex ||= SecureRandom.hex(length)
    end
    
    def reset_secure_token(file)
      model.asset_hex = nil
    end
end
