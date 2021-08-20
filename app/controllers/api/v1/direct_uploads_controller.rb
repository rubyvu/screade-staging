class Api::V1::DirectUploadsController < Api::V1::ApiController
  
  # GET /api/v1/direct_uploads/generate_link
  def generate_link
    # Create Direct upload url request
    direct_url = DirectUpload.call(file_params)
    
    if direct_url.blank?
      render json: { errors: ['Wrong file or file params.'] }, status: :unprocessable_entity
      return
    end
    
    direct_upload_params = {
      direct_upload_url: direct_url[:direct_upload][:url],
      direct_upload_headers: direct_url[:direct_upload][:headers],
      blob_id: direct_url[:blob_signed_id]
    }
    
    render json: { direct_upload_params: direct_upload_params }, status: :ok
  end
  
  private
    def file_params
      params.require(:file).permit(:filename, :byte_size, :checksum, :content_type)
    end
end
