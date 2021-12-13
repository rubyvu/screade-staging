class Api::V1::InvitationsController < Api::V1::ApiController
  
  # POST /api/v1/invitations
  def create
    emails = params[:invitation_emails].split(',')
    
    emails.each do |raw_email|
      email = raw_email.strip.downcase
      
      Invitation.create(
        email: email,
        invited_by_user: current_user
      )
    end
    
    render json: { success: true }, status: :created
  end
  
  # POST /api/v1/hide_popup
  def hide_popup
    current_user.update_columns(hide_invitation_popup: true)
    user_json = UserSerializer.new(current_user).as_json
    render json: { user: user_json }, status: :ok
  end
end
