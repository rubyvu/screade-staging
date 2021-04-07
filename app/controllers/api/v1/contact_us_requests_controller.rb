class Api::V1::ContactUsRequestsController < Api::V1::ApiController
  
  # POST /api/v1/contact_us_requests
  def create
    contact_us_request = ContactUsRequest.new(contact_us_request_params)
    if contact_us_request.save
      contact_us_request_json = ContactUsRequestSerializer.new(contact_us_request).as_json
      render json: { contact_us_request: contact_us_request_json }, status: :ok
    else
      render json: { errors: contact_us_request.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  private
    def contact_us_request_params
      params.require(:contact_us_request).permit(:email, :first_name, :last_name, :message, :subject, :username)
    end
end
