class InvitationsController < ApplicationController
  
  # POST /invitations
  def create
    emails = params[:invitation_emails].split(',')
    
    emails.each do |raw_email|
      email = raw_email.strip.downcase
      
      next unless User::EMAIL_FORMAT.match?(email)
      next if User.exists?(email: email)
      
      Invitation.create(
        email: email,
        invited_by_user: current_user
      )
    end
    
    current_user.update_columns(hide_invitation_popup: true) unless current_user.hide_invitation_popup
    
    redirect_to root_path
  end
  
  # POST /invitations/hide_popup
  def hide_popup
    current_user.update_columns(hide_invitation_popup: true) unless current_user.hide_invitation_popup
    render json: { success: true }, status: :ok
  end
end
