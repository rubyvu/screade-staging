require 'rails_helper'

RSpec.describe Api::V1::CurrentUserController, type: :controller do
  describe 'routing' do
    # GET /api/v1/current_user/info
    it 'is expected to route GET /api/v1/current_user/info to /api/v1/current_user#info' do
      expect(get: '/api/v1/current_user/info').to route_to(
        controller: 'api/v1/current_user',
        action: 'info',
        format: 'json'
      )
    end
    
    # PUT/PATCH /api/v1/current_user
    it 'is expected to route PUT/PATCH /api/v1/current_user to /api/v1/current_user#update' do
      expect(put: '/api/v1/current_user').to route_to(
        controller: 'api/v1/current_user',
        action: 'update',
        format: 'json'
      )
      expect(patch: '/api/v1/current_user').to route_to(
        controller: 'api/v1/current_user',
        action: 'update',
        format: 'json'
      )
    end
  end
  
  before :all do
    @country = Country.first || FactoryBot.create(:country)
    @user_security_question = FactoryBot.create(:user_security_question)
  end
  
  describe 'GET #info' do
    context 'signed up >= 7 days ago' do
      context ':hide_invitation_popup is true' do
        before :all do
          sign_up_date = 8.days.ago
          @user = FactoryBot.create(:user, country: @country, user_security_question: @user_security_question, created_at: sign_up_date, updated_at: sign_up_date, hide_invitation_popup: true)
          @device = FactoryBot.create(:device, owner: @user)
        end
        
        before :each do
          request.headers['X-Device-Token'] = @device.access_token
          get :info
        end
        
        it 'is expected to return :ok (200) HTTP status code' do
          expect(response.status).to eq(200)
        end
        
        it 'is expected to have application/json content type' do
          expect(response.content_type).to eq('application/json; charset=utf-8')
        end
        
        it 'is expected to have current_user' do
          expect(subject.current_user).to eq(@user)
        end
        
        it 'is expected to have :hide_invitation_popup set to true' do
          expect(@user.hide_invitation_popup).to eq(true)
        end
        
        it 'is expected to have :show_invitation_popup in JSON set to false' do
          response_json = JSON.parse(response.body)
          expect(response_json.key?('user')).to eq(true)
          
          user_json = response_json['user']
          expect(user_json.key?('show_invitation_popup')).to eq(true)
          expect(user_json['show_invitation_popup']).to eq(false)
        end
      end
      
      context ':hide_invitation_popup is false' do
        before :all do
          sign_up_date = 8.days.ago
          @user = FactoryBot.create(:user, country: @country, user_security_question: @user_security_question, created_at: sign_up_date, updated_at: sign_up_date, hide_invitation_popup: false)
          @device = FactoryBot.create(:device, owner: @user)
        end
        
        before :each do
          request.headers['X-Device-Token'] = @device.access_token
          get :info
        end
        
        it 'is expected to return :ok (200) HTTP status code' do
          expect(response.status).to eq(200)
        end
        
        it 'is expected to have application/json content type' do
          expect(response.content_type).to eq('application/json; charset=utf-8')
        end
        
        it 'is expected to have current_user' do
          expect(subject.current_user).to eq(@user)
        end
        
        it 'is expected to have :hide_invitation_popup set to false' do
          expect(@user.hide_invitation_popup).to eq(false)
        end
        
        it 'is expected to have :show_invitation_popup in JSON set to true' do
          response_json = JSON.parse(response.body)
          expect(response_json.key?('user')).to eq(true)
          
          user_json = response_json['user']
          expect(user_json.key?('show_invitation_popup')).to eq(true)
          expect(user_json['show_invitation_popup']).to eq(true)
        end
      end
    end
    
    context 'signed up < 7 days ago' do
      context ':hide_invitation_popup is true' do
        before :all do
          sign_up_date = 6.days.ago
          @user = FactoryBot.create(:user, country: @country, user_security_question: @user_security_question, created_at: sign_up_date, updated_at: sign_up_date, hide_invitation_popup: true)
          @device = FactoryBot.create(:device, owner: @user)
        end
        
        before :each do
          request.headers['X-Device-Token'] = @device.access_token
          get :info
        end
        
        it 'is expected to return :ok (200) HTTP status code' do
          expect(response.status).to eq(200)
        end
        
        it 'is expected to have application/json content type' do
          expect(response.content_type).to eq('application/json; charset=utf-8')
        end
        
        it 'is expected to have current_user' do
          expect(subject.current_user).to eq(@user)
        end
        
        it 'is expected to have :hide_invitation_popup set to true' do
          expect(@user.hide_invitation_popup).to eq(true)
        end
        
        it 'is expected to have :show_invitation_popup in JSON set to false' do
          response_json = JSON.parse(response.body)
          expect(response_json.key?('user')).to eq(true)
          
          user_json = response_json['user']
          expect(user_json.key?('show_invitation_popup')).to eq(true)
          expect(user_json['show_invitation_popup']).to eq(false)
        end
      end
      
      context ':hide_invitation_popup is false' do
        before :all do
          sign_up_date = 6.days.ago
          @user = FactoryBot.create(:user, country: @country, user_security_question: @user_security_question, created_at: sign_up_date, updated_at: sign_up_date, hide_invitation_popup: false)
          @device = FactoryBot.create(:device, owner: @user)
        end
        
        before :each do
          request.headers['X-Device-Token'] = @device.access_token
          get :info
        end
        
        it 'is expected to return :ok (200) HTTP status code' do
          expect(response.status).to eq(200)
        end
        
        it 'is expected to have application/json content type' do
          expect(response.content_type).to eq('application/json; charset=utf-8')
        end
        
        it 'is expected to have current_user' do
          expect(subject.current_user).to eq(@user)
        end
        
        it 'is expected to have :hide_invitation_popup set to false' do
          expect(@user.hide_invitation_popup).to eq(false)
        end
        
        it 'is expected to have :show_invitation_popup in JSON set to false' do
          response_json = JSON.parse(response.body)
          expect(response_json.key?('user')).to eq(true)
          
          user_json = response_json['user']
          expect(user_json.key?('show_invitation_popup')).to eq(true)
          expect(user_json['show_invitation_popup']).to eq(false)
        end
      end
    end
  end
  
  describe 'PUT #update' do
    context 'is expected to change :username' do
      before :each do
        @user = FactoryBot.create(:user, country: @country, user_security_question: @user_security_question, hide_invitation_popup: true)
        @device = FactoryBot.create(:device, owner: @user)
        @old_username = @user.username
        @new_username = "#{@old_username}_new"
        user_params = { username: @new_username }
        
        request.headers['X-Device-Token'] = @device.access_token
        put :update, params: { user: user_params }
      end
      
      it 'is expected to return :ok (200) HTTP status code' do
        expect(response.status).to eq(200)
      end
      
      it 'is expected to have application/json content type' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
      
      it 'is expected to have current_user' do
        expect(subject.current_user).to eq(@user)
      end
      
      it 'is expected to update :username for current_user' do
        @user.reload
        expect(@user.username).not_to eq(@old_username)
        expect(@user.username).to eq(@new_username)
      end
    end
  end
end
