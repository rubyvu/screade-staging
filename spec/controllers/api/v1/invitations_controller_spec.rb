require 'rails_helper'

RSpec.describe Api::V1::InvitationsController, type: :controller do
  describe 'routing' do
    # POST /api/v1/invitations
    it 'is expected to route POST /api/v1/invitations to /api/v1/invitations#create' do
      expect(post: '/api/v1/invitations').to route_to(
        controller: 'api/v1/invitations',
        action: 'create',
        format: 'json'
      )
    end
  end
  
  describe 'POST #share' do
    context 'with valid parameters' do
      before :all do
        country = Country.find_by(code: 'US') || FactoryBot.create(:country)
        user_security_question = FactoryBot.create(:user_security_question)
        @user = FactoryBot.create(:user, country: country, user_security_question: user_security_question)
        @device = FactoryBot.create(:device, owner: @user)
      end
      
      before :each do
        @count_of_invitations_before_request = Invitation.count
        request.headers['X-Device-Token'] = @device.access_token
        
        email1 = Faker::Internet.email
        email2 = Faker::Internet.email
        email3 = Faker::Internet.email
        invitation_emails = [email1, email2, email3].join(',')
        post :create, params: { invitation_emails: invitation_emails }
      end
      
      it 'is expected to return :created (201) HTTP status code' do
        expect(response.status).to eq(201)
      end
      
      it 'is expected to have application/json content type' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
      
      it 'is expected to have current_user' do
        expect(subject.current_user).to eq(@user)
      end
      
      it 'is expected to create new Invitations' do
        expect(Invitation.count).to eq(@count_of_invitations_before_request + 3)
      end
      
      it 'is expected to associate current_user with new Invitations' do
        new_invitations = Invitation.order(id: :desc).limit(3)
        invited_by_user_ids = new_invitations.pluck(:invited_by_user_id).uniq
        expect(invited_by_user_ids).to match_array([@user.id])
      end
    end
  end
end
