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
    
    def self.set_presigned_url(store_path)
      asset_type = store_path.split('.').last
      if UserImage::IMAGE_RESOLUTIONS.include?(asset_type)
        uploader = UserImage.new.file
      elsif UserVideo::VIDEO_RESOLUTIONS.include?(asset_type)
        uploader = UserVideo.new.file
      else
        return nil
      end
      
      expires = 1.hour.from_now
      fog_s3 = Fog::AWS::Storage.new(aws_access_key_id: ENV['AWS_S3_ACCESS_KEY_ID'], aws_secret_access_key: ENV['AWS_S3_SECRET_ACCESS_KEY'])
      fog_s3.put_object_url(uploader.fog_directory, store_path, expires)
    end
  end
end
