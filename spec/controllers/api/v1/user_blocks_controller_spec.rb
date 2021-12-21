require 'rails_helper'

RSpec.describe Api::V1::UserBlocksController, type: :controller do
  describe 'routing' do
    # GET /api/v1/user_blocks/:id
    it 'is expected to route GET /api/v1/user_blocks to /api/v1/user_blocks#index' do
      expect(get: '/api/v1/user_blocks').to route_to(
        controller: 'api/v1/user_blocks',
        action: 'index',
        format: 'json'
      )
    end
    
    # POST /api/v1/user_blocks
    it 'is expected to route POST /api/v1/user_blocks to /api/v1/user_blocks#create' do
      expect(post: '/api/v1/user_blocks').to route_to(
        controller: 'api/v1/user_blocks',
        action: 'create',
        format: 'json'
      )
    end
    
    # DELETE /api/v1/user_blocks/:id
    it 'is expected to route DELETE /api/v1/user_blocks to /api/v1/user_blocks#destroy' do
      expect(delete: '/api/v1/user_blocks/USER_ID').to route_to(
        controller: 'api/v1/user_blocks',
        action: 'destroy',
        user_id: 'USER_ID',
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
    
    UserBlock.create(blocker: @user1, blocked: @user2)
    UserBlock.create(blocker: @user1, blocked: @user3)
    UserBlock.create(blocker: @user2, blocked: @user3)
    UserBlock.create(blocker: @user3, blocked: @user1)
    
    @device = FactoryBot.create(:device, owner: @user1)
  end
  
  describe 'GET #index' do
    context 'with valid parameters' do
      before :each do
        request.headers['X-Device-Token'] = @device.access_token
        get :index
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
      
      it 'is expected to return list of UserBlocks' do
        response_json = JSON.parse(response.body)
        expect(response_json.key?('user_blocks')).to eq(true)
        expect(response_json['user_blocks'].count).to eq(2)
      end
    end
  end
  
  describe 'POST #create' do
    context 'with existing UserBlock' do
      before :each do
        UserBlock.where(blocker: @user1, blocked: @user2).first_or_create
        @user_blocks_before_request = UserBlock.count
        
        request.headers['X-Device-Token'] = @device.access_token
        user_block_params = { blocked_user_id: @user2 }
        post :create, params: { user_block: user_block_params }
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
      
      it 'is expected NOT to create a new UserBlock' do
        expect(UserBlock.count).to eq(@user_blocks_before_request)
      end
      
      it 'is expected to return UserBlock' do
        response_json = JSON.parse(response.body)
        expect(response_json.key?('user_block')).to eq(true)
        
        user_block_json = response_json['user_block']
        expect(user_block_json.key?('id')).to eq(true)
        expect(user_block_json.key?('blocked_user')).to eq(true)
      end
    end
    
    context 'WITHOUT existing UserBlock' do
      before :each do
        UserBlock.where(blocker: @user1, blocked: @user2).destroy_all
        @user_blocks_before_request = UserBlock.count
        
        request.headers['X-Device-Token'] = @device.access_token
        user_block_params = { blocked_user_id: @user2 }
        post :create, params: { user_block: user_block_params }
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
      
      it 'is expected to create a new UserBlock' do
        expect(UserBlock.count).to eq(@user_blocks_before_request + 1)
      end
      
      it 'is expected to return UserBlock' do
        response_json = JSON.parse(response.body)
        expect(response_json.key?('user_block')).to eq(true)
        
        user_block_json = response_json['user_block']
        expect(user_block_json.key?('id')).to eq(true)
        expect(user_block_json.key?('blocked_user')).to eq(true)
      end
    end
  end
  
  describe 'DELETE #destroy' do
    context 'with valid parameters' do
      before :each do
        user_block = UserBlock.where(blocker: @user1, blocked: @user2).first_or_create!
        @user_blocks_before_request = UserBlock.count
        
        request.headers['X-Device-Token'] = @device.access_token
        delete :destroy, params: { user_id: @user2.id }
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
      
      it 'is expected to delete a UserBlock' do
        expect(UserBlock.count).to eq(@user_blocks_before_request - 1)
      end
      
      it 'is expected to return UserBlock' do
        response_json = JSON.parse(response.body)
        expect(response_json.key?('user_block')).to eq(true)
        
        user_block_json = response_json['user_block']
        expect(user_block_json.key?('id')).to eq(true)
        expect(user_block_json.key?('blocked_user')).to eq(true)
      end
    end
  end
end
