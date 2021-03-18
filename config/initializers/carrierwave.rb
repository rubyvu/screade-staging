CarrierWave.configure do |config|
  config.fog_credentials = {
    provider:               'AWS',
    aws_access_key_id:      ENV['AWS_S3_ACCESS_KEY_ID'],
    aws_secret_access_key:  ENV['AWS_S3_SECRET_ACCESS_KEY'],
    region:                 ENV['AWS_REGION']
  }
  
  config.fog_directory  = ENV['AWS_S3_PRIVATE_BUCKET']
  config.fog_public     = false
  # # Set URL expiration to 24 hours(in seconds)
  # config.fog_authenticated_url_expiration = 86400
  config.cache_dir      = Rails.root.join('tmp', 'uploads')
  config.max_file_size             = 50.megabytes
  config.min_file_size             = 1.byte
  config.upload_expiration         = 1.hour
end
