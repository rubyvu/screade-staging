require 'rails_helper'

RSpec.describe Api::V1::ChatMessagesController, type: :controller do
  describe 'routing' do
    # POST /api/v1/chats/:chat_access_token/chat_messages
    it 'is expected to route POST /api/v1/chats/:chat_access_token/chat_messages to /api/v1/chat_messages#create' do
      expect(post: '/api/v1/chats/CHAT_TOKEN/chat_messages').to route_to(
        controller: 'api/v1/chat_messages',
        action: 'create',
        chat_access_token: 'CHAT_TOKEN',
        format: 'json'
      )
    end
  end
  
  before :all do
    country = Country.first || FactoryBot.create(:country)
    user_security_question = FactoryBot.create(:user_security_question)
    
    @user1 = FactoryBot.create(:user, country: country, user_security_question: user_security_question)
    @user2 = FactoryBot.create(:user, country: country, user_security_question: user_security_question)
    
    @chat12 = Chat.new(owner: @user1)
    @chat12.chat_memberships.build(user: @user1)
    @chat12.chat_memberships.build(user: @user2)
    @chat12.save!
    
    @device1 = FactoryBot.create(:device, owner: @user1)
  end
  
  describe 'POST #create' do
    context 'message_type: "text"; with text' do
      before :each do
        @chat_messages_before_request = ChatMessage.count
        
        chat_message_params = {
          message_type: 'text',
          text: 'Some RSpec message'
        }
        
        request.headers['X-Device-Token'] = @device1.access_token
        post :create, params: { chat_access_token: @chat12.access_token, chat_message: chat_message_params }
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
      
      it 'is expected to create a new ChatMessage' do
        expect(ChatMessage.count).to eq(@chat_messages_before_request + 1)
      end
    end
    
    context 'message_type: "text"; WITHOUT text' do
      before :each do
        @chat_messages_before_request = ChatMessage.count
        
        chat_message_params = {
          message_type: 'text'
        }
        
        request.headers['X-Device-Token'] = @device1.access_token
        post :create, params: { chat_access_token: @chat12.access_token, chat_message: chat_message_params }
      end
      
      it 'is expected to return :unprocessable_entity (422) HTTP status code' do
        expect(response.status).to eq(422)
      end
      
      it 'is expected to have application/json content type' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
      
      it 'is expected to have current_user' do
        expect(subject.current_user).to eq(@user1)
      end
      
      it 'is expected NOT to create a new ChatMessage' do
        expect(ChatMessage.count).to eq(@chat_messages_before_request)
      end
    end
    
    context 'message_type: "image"; with UserImage' do
      before :each do
        @chat_messages_before_request = ChatMessage.count
        
        filename = 'sample.jpg'
        file_path = Rails.root.join('spec', 'support', 'sample_files', filename)
        file = File.open(file_path)
        user_image = UserImage.new(is_private: false, user: @user1)
        user_image.file.attach(io: file, filename: filename)
        user_image.save!
        
        chat_message_params = {
          message_type: 'image',
          image_id: user_image.id
        }
        
        request.headers['X-Device-Token'] = @device1.access_token
        post :create, params: { chat_access_token: @chat12.access_token, chat_message: chat_message_params }
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
      
      it 'is expected to create a new ChatMessage' do
        expect(ChatMessage.count).to eq(@chat_messages_before_request + 1)
      end
    end
    
    context 'message_type: "image"; with image' do
      before :each do
        @chat_messages_before_request = ChatMessage.count
        
        filename = 'sample.jpg'
        file_path = Rails.root.join('spec', 'support', 'sample_files', filename)
        file = File.open(file_path)
        blob = ActiveStorage::Blob.create_and_upload!(io: file, filename: filename)
        
        chat_message_params = {
          message_type: 'image',
          image: blob.signed_id
        }
        
        request.headers['X-Device-Token'] = @device1.access_token
        post :create, params: { chat_access_token: @chat12.access_token, chat_message: chat_message_params }
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
      
      it 'is expected to create a new ChatMessage' do
        expect(ChatMessage.count).to eq(@chat_messages_before_request + 1)
      end
    end
    
    context 'message_type: "image"; WITHOUT UserImage or image' do
      before :each do
        @chat_messages_before_request = ChatMessage.count
        
        chat_message_params = {
          message_type: 'image'
        }
        
        request.headers['X-Device-Token'] = @device1.access_token
        post :create, params: { chat_access_token: @chat12.access_token, chat_message: chat_message_params }
      end
      
      it 'is expected to return :unprocessable_entity (422) HTTP status code' do
        expect(response.status).to eq(422)
      end
      
      it 'is expected to have application/json content type' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
      
      it 'is expected to have current_user' do
        expect(subject.current_user).to eq(@user1)
      end
      
      it 'is expected to create a new ChatMessage' do
        expect(ChatMessage.count).to eq(@chat_messages_before_request)
      end
    end
    
    context 'message_type: "video"; with UserVideo' do
      before :each do
        @chat_messages_before_request = ChatMessage.count
        
        filename = 'sample.mp4'
        file_path = Rails.root.join('spec', 'support', 'sample_files', filename)
        file = File.open(file_path)
        user_video = UserVideo.new(is_private: false, user: @user1)
        user_video.file.attach(io: file, filename: filename)
        user_video.save!
        
        chat_message_params = {
          message_type: 'video',
          video_id: user_video.id
        }
        
        request.headers['X-Device-Token'] = @device1.access_token
        post :create, params: { chat_access_token: @chat12.access_token, chat_message: chat_message_params }
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
      
      it 'is expected to create a new ChatMessage' do
        expect(ChatMessage.count).to eq(@chat_messages_before_request + 1)
      end
    end
    
    context 'message_type: "video"; with video' do
      before :each do
        @chat_messages_before_request = ChatMessage.count
        
        filename = 'sample.mp4'
        file_path = Rails.root.join('spec', 'support', 'sample_files', filename)
        file = File.open(file_path)
        blob = ActiveStorage::Blob.create_and_upload!(io: file, filename: filename)
        
        chat_message_params = {
          message_type: 'video',
          video: blob.signed_id
        }
        
        request.headers['X-Device-Token'] = @device1.access_token
        post :create, params: { chat_access_token: @chat12.access_token, chat_message: chat_message_params }
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
      
      it 'is expected to create a new ChatMessage' do
        expect(ChatMessage.count).to eq(@chat_messages_before_request + 1)
      end
    end
    
    context 'message_type: "video"; WITHOUT UserVideo or video' do
      before :each do
        @chat_messages_before_request = ChatMessage.count
        
        chat_message_params = {
          message_type: 'video'
        }
        
        request.headers['X-Device-Token'] = @device1.access_token
        post :create, params: { chat_access_token: @chat12.access_token, chat_message: chat_message_params }
      end
      
      it 'is expected to return :unprocessable_entity (422) HTTP status code' do
        expect(response.status).to eq(422)
      end
      
      it 'is expected to have application/json content type' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
      
      it 'is expected to have current_user' do
        expect(subject.current_user).to eq(@user1)
      end
      
      it 'is expected to create a new ChatMessage' do
        expect(ChatMessage.count).to eq(@chat_messages_before_request)
      end
    end
  end
end
