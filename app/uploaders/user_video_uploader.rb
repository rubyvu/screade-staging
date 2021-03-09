class UserVideoUploader < CarrierWave::Uploader::Base
  include CarrierWaveDirect::Uploader
  
  # Callbacks
  before :cache, :reset_secure_token
  
  def filename
    "#{secure_token(8)}-video.#{file.extension}" if original_filename
  end
  
  def extension_white_list
    %w(mp4)
  end
  
  protected
    def secure_token(length)
      model.file_hex ||= SecureRandom.hex(length)
    end
    
    def reset_secure_token(file)
      model.file_hex = nil
    end
end
