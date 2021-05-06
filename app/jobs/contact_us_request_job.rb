class ContactUsRequestJob < ApplicationJob
  
  def run(contact_us_request_id)
    contact = ContactUsRequest.find_by(id: contact_us_request_id)
    return unless contact
    
    ContactUsRequestMailer.notify_admin(contact_us_request_id).deliver_now
  end
end
