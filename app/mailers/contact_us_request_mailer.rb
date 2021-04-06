class ContactUsRequestMailer < ApplicationMailer

  def notify_admin(contact_us_request_id)
    @contact_us_request = ContactUsRequest.find_by(id: contact_us_request_id)
    return unless @contact_us_request
    
    mail to: 'screade@mail.com', from: @contact_us_request.email, subject: @contact_us_request.subject
  end
end
