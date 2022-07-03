class InvitationMailer < ApplicationMailer
  
  def send_out(invitation)
    @invitation = invitation
    mail to: @invitation.email, subject: "#{@invitation.invited_by_user.greeting} has invited you to join Screade®"
  end
end
