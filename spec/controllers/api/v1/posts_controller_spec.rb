require 'rails_helper'

RSpec.describe Api::V1::PostsController, type: :controller do
  describe 'routing' do
    # POST /api/v1/posts
    it 'is expected to route POST /api/v1/posts to /api/v1/posts#create' do
      expect(post: '/api/v1/posts').to route_to(
        controller: 'api/v1/posts',
        action: 'create',
        format: 'json'
      )
    end
    
    # GET /api/v1/posts/:id/lits
    it 'is expected to route GET /api/v1/posts/:id/lits to /api/v1/posts#lits' do
      expect(get: '/api/v1/posts/POST_ID/lits').to route_to(
        controller: 'api/v1/posts',
        action: 'lits',
        id: 'POST_ID',
        format: 'json'
      )
    end
    
    # POST /api/v1/posts/:id/share
    it 'is expected to route POST /api/v1/posts/:id/share to /api/v1/posts#share' do
      expect(post: '/api/v1/posts/POST_ID/share').to route_to(
        controller: 'api/v1/posts',
        action: 'share',
        id: 'POST_ID',
        format: 'json'
      )
    end
    
    # POST /api/v1/posts/:id/translate
    it 'is expected to route POST /api/v1/posts/:id/translate to /api/v1/posts#translate' do
      expect(post: '/api/v1/posts/POST_ID/translate').to route_to(
        controller: 'api/v1/posts',
        action: 'translate',
        id: 'POST_ID',
        format: 'json'
      )
    end
    
    # DELETE /api/v1/posts/:id
    it 'is expected to route DELETE /api/v1/posts/:id to /api/v1/posts#destroy' do
      expect(delete: '/api/v1/posts/POST_ID').to route_to(
        controller: 'api/v1/posts',
        action: 'destroy',
        id: 'POST_ID',
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
    
    news_category = FactoryBot.create(:news_category)
    @topic = FactoryBot.create(:topic, parent: news_category)
    @post = FactoryBot.create(:post, source: @topic, user: @sender)
    @users.each do |user|
      Lit.create(source: @post, user: user)
    end
  end
  
  describe 'POST #create' do
    context 'WITHOUT attachments' do
      before :each do
        post_params = {
          title: Faker::Lorem.characters(number: 10),
          description: Faker::Lorem.characters(number: 50),
          source_type: 'Topic',
          source_id: @topic.id
        }
        
        request.headers['X-Device-Token'] = @device.access_token
        post :create, params: { post: post_params }
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
      
      it 'is expected to return Post in response' do
        response_json = JSON.parse(response.body)
        expect(response_json.key?('post')).to eq(true)
      end
    end
    
    context 'with attached UserImage' do
      before :each do
        filename = 'sample.jpg'
        file_path = Rails.root.join('spec', 'support', 'sample_files', filename)
        file = File.open(file_path)
        user_image = UserImage.new(is_private: false, user: @sender)
        user_image.file.attach(io: file, filename: filename)
        user_image.save!
        
        post_params = {
          title: Faker::Lorem.characters(number: 10),
          description: Faker::Lorem.characters(number: 50),
          source_type: 'Topic',
          source_id: @topic.id,
          image_id: user_image.id
        }
        
        request.headers['X-Device-Token'] = @device.access_token
        post :create, params: { post: post_params }
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
      
      it 'is expected to return Post in response' do
        response_json = JSON.parse(response.body)
        expect(response_json.key?('post')).to eq(true)
      end
    end
    
    context 'with attached UserVideo' do
      before :each do
        filename = 'sample.mp4'
        file_path = Rails.root.join('spec', 'support', 'sample_files', filename)
        file = File.open(file_path)
        user_video = UserVideo.new(is_private: false, user: @sender)
        user_video.file.attach(io: file, filename: filename)
        user_video.save!
        
        post_params = {
          title: Faker::Lorem.characters(number: 10),
          description: Faker::Lorem.characters(number: 50),
          source_type: 'Topic',
          source_id: @topic.id,
          video_id: user_video.id
        }
        
        request.headers['X-Device-Token'] = @device.access_token
        post :create, params: { post: post_params }
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
      
      it 'is expected to return Post in response' do
        response_json = JSON.parse(response.body)
        expect(response_json.key?('post')).to eq(true)
      end
    end
  end
  
  describe 'GET #lits' do
    context 'with valid parameters' do
      before :each do
        request.headers['X-Device-Token'] = @device.access_token
        get :lits, params: { id: @post.id }
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
      
      it 'is expected to return Lits for NewsArticle' do
        response_json = JSON.parse(response.body)
        expect(response_json.key?('lits')).to eq(true)
        
        lits_json = response_json['lits']
        expect(lits_json.count).to eq(3)
      end
    end
  end
  
  describe 'POST #share' do
    context 'with valid parameters' do
      before :each do
        @count_of_shared_records_before_request = SharedRecord.count
        request.headers['X-Device-Token'] = @device.access_token
        
        shared_record_params = { user_ids: @users.map(&:id) }
        post :share, params: { id: @post.id, shared_record: shared_record_params }
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
      
      it 'is expected to associate Post with a new SharedRecord' do
        new_shared_record = SharedRecord.order(id: :desc).first
        expect(new_shared_record.shareable).to eq(@post)
      end
    end
  end
  
  describe 'POST #translate' do
    context 'with valid parameters' do
      before :each do
        request.headers['X-Device-Token'] = @device.access_token
        post :translate, params: { id: @post.id }
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
      
      it 'is expected to return translated :title and :description in JSON' do
        response_json = JSON.parse(response.body)
        expect(response_json.key?('post')).to eq(true)
        
        post_json = response_json['post']
        expect(post_json.key?('title')).to eq(true)
        expect(post_json.key?('description')).to eq(true)
      end
    end
  end
  
  describe 'DELETE #destroy' do
    context 'current_user is owner' do
      before :each do
        @post_to_delete = FactoryBot.create(:post, source: @topic, user: @sender)
        @posts_before_request = Post.count
        
        request.headers['X-Device-Token'] = @device.access_token
        delete :destroy, params: { id: @post_to_delete.id }
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
        expect(Post.count).to eq(@posts_before_request - 1)
      end
      
      it 'is expected to return :success in JSON' do
        response_json = JSON.parse(response.body)
        expect(response_json.key?('success')).to eq(true)
      end
    end
    
    context 'current_user is NOT owner' do
      before :each do
        @post_to_delete = FactoryBot.create(:post, source: @topic, user: @users.first)
        @posts_before_request = Post.count
        
        request.headers['X-Device-Token'] = @device.access_token
        delete :destroy, params: { id: @post_to_delete.id }
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
        expect(Post.count).to eq(@posts_before_request)
      end
      
      it 'is expected to return :success in JSON' do
        response_json = JSON.parse(response.body)
        expect(response_json.key?('success')).to eq(true)
      end
    end
  end
end
