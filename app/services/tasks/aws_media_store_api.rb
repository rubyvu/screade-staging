module Tasks
  class AwsMediaStoreApi
    @aws_client = Aws::MediaStore::Client.new(
      region: ENV['AWS_REGION'],
      access_key_id: ENV['AWS_MEDIA_PACKAGE_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_MEDIA_PACKAGE_SECRET_ACCESS_KEY']
    )
    
    def self.get_container
      begin
        @aws_client.list_containers({max_results: 1}).containers[0]
      rescue
        nil
      end
    end
    
  end
end
