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
  end
  
  describe 'POST #share' do
    context 'with valid parameters' do
      before :all do
        country = Country.find_by(code: 'US') || FactoryBot.create(:country)
        user_security_question = FactoryBot.create(:user_security_question)
        @sender = FactoryBot.create(:user, country: country, user_security_question: user_security_question)
        @device = FactoryBot.create(:device, owner: @sender)
        
        @users = FactoryBot.create_list(:user, 3, country: country, user_security_question: user_security_question)
        
        news_article = FactoryBot.create(:news_article, country: country)
        @comment = FactoryBot.create(:comment, user: @sender, source: news_article)
      end
      
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
end
