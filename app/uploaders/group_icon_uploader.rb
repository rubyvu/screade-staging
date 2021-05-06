class GroupIconUploader < CarrierWave::Uploader::Base
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
  
  def extension_white_list
    %w(jpg jpeg png)
  end
  
  def default_url
    ActionController::Base.helpers.asset_pack_path('media/images/placeholders/placeholder-group-category-icon.png')
  end
end
