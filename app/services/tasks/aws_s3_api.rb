module Tasks
  class AwsS3Api
    
    def self.get_presigned_url(key)
      aws_client = Aws::S3::Client.new(
        region: ENV['AWS_REGION'],
        access_key_id: ENV['AWS_S3_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_S3_SECRET_ACCESS_KEY']
      )
      
      s3 = Aws::S3::Resource.new(client: aws_client)
      bucket = s3.bucket(ENV['AWS_S3_PRIVATE_BUCKET'])
      obj = bucket.object(key)
      obj.presigned_url(:get)
    end
  end
end
