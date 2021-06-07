if Rails.env.production?
  Searchkick.aws_credentials = {
    access_key_id: ENV["AWS_ES_ACCESS_KEY_ID"],
    secret_access_key: ENV["AWS_ES_SECRET_ACCESS_KEY"],
    region: ENV["AWS_REGION"]
  }
end
