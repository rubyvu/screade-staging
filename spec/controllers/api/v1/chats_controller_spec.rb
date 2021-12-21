require 'rails_helper'

RSpec.describe Api::V1::ChatsController, type: :controller do
  describe 'routing' do
    # POST /api/v1/chats/direct_message
    it 'is expected to route POST /api/v1/chats/direct_message to /api/v1/chats#create' do
      expect(post: '/api/v1/chats/direct_message').to route_to(
        controller: 'api/v1/chats',
        action: 'direct_message',
        format: 'json'
      )
    end
  end
  
  before :all do
    country = Country.first || FactoryBot.create(:country)
    user_security_question = FactoryBot.create(:user_security_question)
    
    @user1 = FactoryBot.create(:user, country: country, user_security_question: user_security_question)
    @user2 = FactoryBot.create(:user, country: country, user_security_question: user_security_question)
    @user3 = FactoryBot.create(:user, country: country, user_security_question: user_security_question)
    
    @chat123 = Chat.new(owner: @user1)
    @chat123.chat_memberships.build(user: @user1)
    @chat123.chat_memberships.build(user: @user2)
    @chat123.chat_memberships.build(user: @user3)
    @chat123.save!
    
    @device = FactoryBot.create(:device, owner: @user1)
  end
  
  describe 'POST #direct_message' do
    context 'with existing Chat' do
      before :each do
        @chat12 = Chat.new(owner: @user1)
        @chat12.chat_memberships.build(user: @user1)
        @chat12.chat_memberships.build(user: @user2)
        @chat12.save!
        
        @chats_before_request = Chat.count
        
        request.headers['X-Device-Token'] = @device.access_token
        post :direct_message, params: { user_id: @user2.id }
      end
      
      it 'is expected to return :ok (200) HTTP status code' do
        expect(response.status).to eq(200)
      end
      
      it 'is expected to have application/json content type' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
      
      it 'is expected to have current_user' do
        expect(subject.current_user).to eq(@user1)
      end
      
      it 'is expected NOT to create a new Chat' do
        expect(Chat.count).to eq(@chats_before_request)
      end
      
      it 'is expected to return Chat' do
        response_json = JSON.parse(response.body)
        expect(response_json.key?('chat')).to eq(true)
      end
    end
    
    context 'WITHOUT existing Chat' do
      before :each do
        Chat.joins(:chat_memberships).where(chat_memberships: { user: @user1 }).destroy_all
        @chats_before_request = Chat.count
        
        request.headers['X-Device-Token'] = @device.access_token
        post :direct_message, params: { user_id: @user2.id }
      end
      
      it 'is expected to return :ok (200) HTTP status code' do
        expect(response.status).to eq(200)
      end
      
      it 'is expected to have application/json content type' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
      
      it 'is expected to have current_user' do
        expect(subject.current_user).to eq(@user1)
      end
      
      it 'is expected to create a new Chat' do
        expect(Chat.count).to eq(@chats_before_request + 1)
      end
      
      it 'is expected to return Chat' do
        response_json = JSON.parse(response.body)
        expect(response_json.key?('chat')).to eq(true)
      end
    end
  end
end
