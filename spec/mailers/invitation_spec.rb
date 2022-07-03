require 'rails_helper'

RSpec.describe InvitationMailer, type: :mailer do
  describe 'send_out' do
    let(:mail) { InvitationMailer.send }
    
    it 'renders the headers' do
      expect(mail.subject).to eq('Send')
      expect(mail.to).to eq(['to@example.org'])
      expect(mail.from).to eq(['from@example.com'])
    end
    
    it 'renders the body' do
      expect(mail.body.encoded).to match('Hi')
    end
  end
end
