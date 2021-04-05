class Api::V1::UsersController < Api::V1::ApiController
  
  # POST /api/v1/contacts
  def create
    contact = Contact.new(contact_params)
    if contact.save
      contact_json = ContactSerializer.new(contact).as_json
      render json: { contact: contact_json }, status: :ok
    else
      render json: { errors: contact.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  private
    def change_password_params
      params.require(:contact).permit(:email, :first_name, :last_name, :message, :subject, :username)
    end
end
