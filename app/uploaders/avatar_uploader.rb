class AvatarUploader < CarrierWave::Uploader::Base
  # Callbacks
  before :cache, :reset_secure_token
  
  # Image processor
  include CarrierWave::MiniMagick
  
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
      model.profile_picture_hex ||= SecureRandom.hex(length)
    end
    
    def reset_secure_token(file)
      model.profile_picture_hex = nil
    end
end
