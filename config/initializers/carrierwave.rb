CarrierWave.configure do |config|
  config.fog_credentials = {
    provider:               'AWS',
    aws_access_key_id:      ENV['AWS_ACCESS_KEY_ID'],
    aws_secret_access_key:  ENV['AWS_SECRET_ACCESS_KEY'],
    region:                 ENV['AWS_REGION']
  }
  if Rails.env.development?
    config.fog_directory = ENV['AWS_S3_PUBLIC_BUCKET']
    config.fog_public    = true
  else
    config.fog_directory  = ENV['AWS_S3_PRIVATE_BUCKET']
    config.fog_public     = false
    # Set URL expiration to 24 hours(in seconds)
    config.fog_authenticated_url_expiration = 86400
  end
  config.cache_dir      = Rails.root.join('tmp', 'uploads')
end
