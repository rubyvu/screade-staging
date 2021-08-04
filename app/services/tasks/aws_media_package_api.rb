module Tasks
  class AwsMediaPackageApi
    @aws_client = Aws::MediaPackage::Client.new(
      region: ENV['AWS_REGION'],
      access_key_id: ENV['AWS_MEDIA_PACKAGE_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_MEDIA_PACKAGE_SECRET_ACCESS_KEY']
    )
    
    def self.create_channel
      response = @aws_client.create_channel({ id: "screade-mp-channel-test-1" })
      # Save response.arn
      # Save response.id
      # Save response.hls_ingest.ingest_endpoints[0].id #=> String
      # Save response.hls_ingest.ingest_endpoints[0].password #=> String
      # Save response.hls_ingest.ingest_endpoints[0].url #=> String
      # Save response.hls_ingest.ingest_endpoints[0].username #=> String
      
      response
    end
    
    def self.delete_channel
      @aws_client.delete_channel({ id: "screade-mp-channel-test-1" })
    end
    
    def self.create_origin_endpoint
      response = @aws_client.create_origin_endpoint({
        channel_id: "screade-mp-channel-test-1",
        id: "screade-mp-endpoint-test-1",
        hls_package: {}
      })
      puts response
    end
    
    def self.delete_origin_endpoint
      @aws_client.delete_origin_endpoint({ id: "screade-mp-endpoint-test-1" })
    end
    
    def self.list_origin_endpoints(channel_id)
      @aws_client.list_origin_endpoints({ channel_id: channel_id })
    end
    
  end
end
