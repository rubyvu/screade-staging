require 'rails_helper'

RSpec.describe Api::V1::CommentsController, type: :controller do
  describe 'routing' do
    # POST /api/v1/comments/:id/share
    it 'is expected to route POST /api/v1/comments/:id/share to /api/v1/comments#share' do
      expect(post: '/api/v1/comments/COMMENT_ID/share').to route_to(
        controller: 'api/v1/comments',
        action: 'share',
        id: 'COMMENT_ID',
        format: 'json'
      )
    end
    
    # POST /api/v1/comments/:id/translate
    it 'is expected to route POST /api/v1/comments/:id/translate to /api/v1/comments#translate' do
      expect(post: '/api/v1/comments/COMMENT_ID/translate').to route_to(
        controller: 'api/v1/comments',
        action: 'translate',
        id: 'COMMENT_ID',
        format: 'json'
      )
    end
    
    # DELETE /api/v1/comments/:id
    it 'is expected to route DELETE /api/v1/comments/:id to /api/v1/comments#destroy' do
      expect(delete: '/api/v1/comments/COMMENT_ID').to route_to(
        controller: 'api/v1/comments',
        action: 'destroy',
        id: 'COMMENT_ID',
        format: 'json'
      )
    end
  end
  
  before :all do
    country = Country.find_by(code: 'US') || FactoryBot.create(:country)
    user_security_question = FactoryBot.create(:user_security_question)
    @sender = FactoryBot.create(:user, country: country, user_security_question: user_security_question)
    @device = FactoryBot.create(:device, owner: @sender)
    
    @users = FactoryBot.create_list(:user, 3, country: country, user_security_question: user_security_question)
    
    @news_article = FactoryBot.create(:news_article, country: country)
    @comment = FactoryBot.create(:comment, user: @sender, source: @news_article)
  end
  
  describe 'POST #share' do
    context 'with valid parameters' do
      before :each do
        @count_of_shared_records_before_request = SharedRecord.count
        request.headers['X-Device-Token'] = @device.access_token
        
        shared_record_params = { user_ids: @users.map(&:id) }
        post :share, params: { id: @comment.id, shared_record: shared_record_params }
      end
      
      it 'is expected to return :created (201) HTTP status code' do
        expect(response.status).to eq(201)
      end
      
      it 'is expected to have application/json content type' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
      
      it 'is expected to have current_user' do
        expect(subject.current_user).to eq(@sender)
      end
      
      it 'is expected to create a new SharedRecord' do
        expect(SharedRecord.count).to eq(@count_of_shared_records_before_request + 1)
      end
      
      it 'is expected to associate Users with a new SharedRecord' do
        new_shared_record = SharedRecord.order(id: :desc).first
        expect(new_shared_record.users.ids).to match_array(@users.map(&:id))
      end
      
      it 'is expected to associate Comment with a new SharedRecord' do
        new_shared_record = SharedRecord.order(id: :desc).first
        expect(new_shared_record.shareable).to eq(@comment)
      end
    end
  end
  
  describe 'POST #translate' do
    context 'with valid parameters' do
      before :each do
        request.headers['X-Device-Token'] = @device.access_token
        post :translate, params: { id: @comment.id }
      end
      
      it 'is expected to return :ok (200) HTTP status code' do
        expect(response.status).to eq(200)
      end
      
      it 'is expected to have application/json content type' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
      
      it 'is expected to have current_user' do
        expect(subject.current_user).to eq(@sender)
      end
      
      it 'is expected to return translated :message in JSON' do
        response_json = JSON.parse(response.body)
        expect(response_json.key?('comment')).to eq(true)
        
        comment_json = response_json['comment']
        expect(comment_json.key?('message')).to eq(true)
      end
    end
  end
  
  describe 'DELETE #destroy' do
    context 'current_user is owner' do
      before :each do
        @comment_to_delete = FactoryBot.create(:comment, user: @sender, source: @news_article)
        @comments_before_request = Comment.count
        
        request.headers['X-Device-Token'] = @device.access_token
        delete :destroy, params: { id: @comment_to_delete.id }
      end
      
      it 'is expected to return :ok (200) HTTP status code' do
        expect(response.status).to eq(200)
      end
      
      it 'is expected to have application/json content type' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
      
      it 'is expected to have current_user' do
        expect(subject.current_user).to eq(@sender)
      end
      
      it 'is expected to delete Post' do
        expect(Comment.count).to eq(@comments_before_request - 1)
      end
      
      it 'is expected to return :success in JSON' do
        response_json = JSON.parse(response.body)
        expect(response_json.key?('success')).to eq(true)
      end
    end
    
    context 'current_user is NOT owner' do
      before :each do
        @comment_to_delete = FactoryBot.create(:comment, user: @users.first, source: @news_article)
        @comments_before_request = Comment.count
        
        request.headers['X-Device-Token'] = @device.access_token
        delete :destroy, params: { id: @comment_to_delete.id }
      end
      
      it 'is expected to return :forbidden (403) HTTP status code' do
        expect(response.status).to eq(403)
      end
      
      it 'is expected to have application/json content type' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
      
      it 'is expected to have current_user' do
        expect(subject.current_user).to eq(@sender)
      end
      
      it 'is expected to NOT delete Post' do
        expect(Comment.count).to eq(@comments_before_request)
      end
      
      it 'is expected to return :success in JSON' do
        response_json = JSON.parse(response.body)
        expect(response_json.key?('success')).to eq(true)
      end
    end
  end
end
