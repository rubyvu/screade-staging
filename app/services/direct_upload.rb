class DirectUpload < BaseService
  def initialize(blob_args, **options)
    @blob_args = blob_args.to_h.deep_symbolize_keys
    @expiration_time = options[:expiration_time] || 10.minutes
    @folder = options[:folder]
  end
  
  def call
    blob = create_blob
    response = signed_url(blob)
    response[:blob_signed_id] = blob.signed_id
    response
  end
  
  private
    attr_reader :blob_args, :expiration_time, :folder
    
    def create_blob
      blob = ActiveStorage::Blob.create_before_direct_upload!(blob_args)
      blob.update_attribute(:key, "#{folder}/#{blob.key}") if folder.present?
      blob
    end
    
    def signed_url(blob)
      response_signature(
        blob.service_url_for_direct_upload(expires_in: expiration_time),
        headers: blob.service_headers_for_direct_upload
      )
    end
    
    def response_signature(url, **params)
      { direct_upload: { url: url }.merge(params) }
    end
end
