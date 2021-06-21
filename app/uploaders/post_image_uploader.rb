class PostImageUploader < CarrierWave::Uploader::Base
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
  
  version :rectangle_300_250 do
    process resize_to_fill: [300, 250]
  end
  
  protected
    def secure_token(length)
      model.image_hex ||= SecureRandom.hex(length)
    end
    
    def reset_secure_token(file)
      model.image_hex = nil
    end
end
