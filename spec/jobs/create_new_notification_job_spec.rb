require 'rails_helper'

RSpec.describe CreateNewNotificationJob, type: :job do
  include ActiveJob::TestHelper
  
  before :all do
    @country = Country.find_by(code: 'US') || FactoryBot.create(:country, code: 'US')
    @user_security_question = FactoryBot.create(:user_security_question)
    @user = FactoryBot.create(:user, country: @country, user_security_question: @user_security_question)
    news_category = FactoryBot.create(:news_category)
    @topic = FactoryBot.create(:topic, parent: news_category)
    @post = FactoryBot.build(:post, source: @topic, user: @user)
    @news_article = FactoryBot.create(:news_article, country: @country)
    @recipient = FactoryBot.create(:user, country: @country, user_security_question: @user_security_question)
  end
  
  it 'should create Notification for shared Comment' do
    comment = FactoryBot.create(:comment, user: @user, source: @news_article)
    shared_record = FactoryBot.create(:shared_record, sender: @user, shareable: comment, users: [@recipient])
    
    perform_enqueued_jobs do
      CreateNewNotificationJob.perform_later(shared_record.id, 'SharedRecord')
    end
    
    notification = Notification.order(id: :desc).first
    expect(notification.source_id).to eq(comment.id)
    expect(notification.source_type).to eq('Comment')
    expect(notification.sender_id).to eq(@user.id)
    expect(notification.recipient_id).to eq(@recipient.id)
    expect(notification.is_shared).to eq(true)
  end
  
  it 'should create Notification for shared NewsArticle' do
    shared_record = FactoryBot.create(:shared_record, sender: @user, shareable: @news_article, users: [@recipient])
    
    perform_enqueued_jobs do
      CreateNewNotificationJob.perform_later(shared_record.id, 'SharedRecord')
    end
    
    notification = Notification.order(id: :desc).first
    expect(notification.source_id).to eq(@news_article.id)
    expect(notification.source_type).to eq('NewsArticle')
    expect(notification.sender_id).to eq(@user.id)
    expect(notification.recipient_id).to eq(@recipient.id)
    expect(notification.is_shared).to eq(true)
  end
  
  it 'should create Notification for shared Post' do
    post = FactoryBot.create(:post, source: @topic, user: @user)
    shared_record = FactoryBot.create(:shared_record, sender: @user, shareable: post, users: [@recipient])
    
    perform_enqueued_jobs do
      CreateNewNotificationJob.perform_later(shared_record.id, 'SharedRecord')
    end
    
    notification = Notification.order(id: :desc).first
    expect(notification.source_id).to eq(post.id)
    expect(notification.source_type).to eq('Post')
    expect(notification.sender_id).to eq(@user.id)
    expect(notification.recipient_id).to eq(@recipient.id)
    expect(notification.is_shared).to eq(true)
  end
end
