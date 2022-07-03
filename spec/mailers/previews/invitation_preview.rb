# Preview all emails at http://localhost:3000/rails/mailers/invitation
class InvitationPreview < ActionMailer::Preview
  
  # Preview this email at http://localhost:3000/rails/mailers/invitation/send_out
  def send_out
    invited_by = User.last
    unless invited_by
      country = Country.find_by(code: 'US') || FactoryBot.create(:country, code: 'US')
      user_security_question = FactoryBot.create(:user_security_question)
      invited_by = FactoryBot.create(:user, country: country, user_security_question: user_security_question)
    end
    
    invitation = FactoryBot.create(:invitation, invited_by_user: invited_by)
    InvitationMailer.send_out(invitation)
  end
end
