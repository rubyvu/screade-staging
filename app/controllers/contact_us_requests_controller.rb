class ContactUsRequestsController < ApplicationController
  
  # GET /contact_us_requests
  def new
  end
  
  # POST /contact_us_requests
  def create
    contact_us_request = ContactUsRequest.new(contact_us_request_params)
    if contact_us_request.save
      redirect_to root_path
    else
      flash[:error] = contact_us_request.errors.full_messages
      render 'new'
    end
  end
  
  private
    def contact_us_request_params
      params.require(:contact_us_request).permit(:email, :first_name, :last_name, :message, :subject, :username)
    end
end
