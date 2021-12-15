require 'rails_helper'

RSpec.describe Api::V1::ReportsController, type: :controller do
  describe 'routing' do
    # POST /api/v1/reports
    it 'is expected to route POST /api/v1/reports to /api/v1/reports#create' do
      expect(post: '/api/v1/reports').to route_to(
        controller: 'api/v1/reports',
        action: 'create',
        format: 'json'
      )
    end
  end
  
  before :all do
    country = Country.first || FactoryBot.create(:country)
    user_security_question = FactoryBot.create(:user_security_question)
    
    @user1 = FactoryBot.create(:user, country: country, user_security_question: user_security_question)
    @user2 = FactoryBot.create(:user, country: country, user_security_question: user_security_question)
    
    @device = FactoryBot.create(:device, owner: @user1)
  end
  
  describe 'POST #create' do
    context 'with valid parameters' do
      before :each do
        @reports_before_request = Report.count
        
        request.headers['X-Device-Token'] = @device.access_token
        report_params = { reported_user_id: @user2, details: Faker::Lorem.paragraph }
        post :create, params: { report: report_params }
      end
      
      it 'is expected to return :created (201) HTTP status code' do
        expect(response.status).to eq(201)
      end
      
      it 'is expected to have application/json content type' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
      
      it 'is expected to have current_user' do
        expect(subject.current_user).to eq(@user1)
      end
      
      it 'is expected to create a new Report' do
        expect(Report.count).to eq(@reports_before_request + 1)
      end
      
      it 'is expected to return Report' do
        response_json = JSON.parse(response.body)
        expect(response_json.key?('report')).to eq(true)
        
        report_json = response_json['report']
        expect(report_json.key?('id')).to eq(true)
        expect(report_json.key?('details')).to eq(true)
        expect(report_json.key?('reported_user')).to eq(true)
      end
    end
  end
end
