class ContactMailer < ApplicationMailer

  def notify_admin(contact_id)
    @contact = Contact.find_by(id: contact_id)
    return unless @contact
    
    mail to: 'screade@mail.com', from: @contact.email, subject: @contact.subject
  end
end
