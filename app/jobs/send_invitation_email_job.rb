class SendInvitationEmailJob < ApplicationJob
  
  def run(invitation_id)
    invitation = Invitation.find_by(id: invitation_id)
    return unless invitation
    
    InvitationMailer.send_out(invitation).deliver_now
  end
end
