class ContactUsJob < ApplicationJob
  
  def run(contact_id)
    contact = Contact.find_by(id: contact_id)
    return unless contact
    
    ContactMailer.notify_admin(contact_id).deliver_now
  end
end
