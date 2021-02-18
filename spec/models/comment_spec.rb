require 'rails_helper'

RSpec.describe Comment, type: :model do
  before :all do
    @country = Country.find_by(code: 'US') || FactoryBot.create(:country, code: 'US')
    @user_security_question = FactoryBot.create(:user_security_question)
    @user = FactoryBot.create(:user, country: @country, user_security_question: @user_security_question)
    @news_article = FactoryBot.create(:news_article, country: @country)
  end
  
  it 'should have a valid factory' do
    expect(FactoryBot.build(:comment, user: @user, source: @news_article)).to be_valid
  end
  
  context 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:source) }
  end
  
  context 'validations' do
    subject { FactoryBot.build(:comment, user: @user, source: @news_article) }
    
    context 'associations' do
    end
    
    context 'fields' do
      it { should validate_presence_of(:message) }
      it { should validate_presence_of(:source_id) }
      it { should validate_presence_of(:source_type) }
    end
  end
  
  context 'object' do
    before :all do
      @country = Country.find_by(code: 'US') || FactoryBot.create(:country, code: 'US')
      @user_security_question = FactoryBot.create(:user_security_question)
    end
    
    it 'should set User Comment to NewsArticles' do
      user = FactoryBot.create(:user, country: @country, user_security_question: @user_security_question)
      news_article = FactoryBot.create(:news_article, country: @country)
      
      # Check that there no comments for new objects
      expect(user.comments.count).to eq(0)
      expect(user.commented_news_articles.count).to eq(0)
      expect(news_article.comments.count).to eq(0)
      expect(news_article.commenting_users.count).to eq(0)
      
      comment_for_article = FactoryBot.create(:comment, user: user, source: news_article)
      
      # Check that all associations between User, Comment and NewsArticle are created
      expect(user.comments.count).to eq(1)
      expect(user.comments.first).to eq(comment_for_article)
      
      expect(user.commented_news_articles.count).to eq(1)
      expect(user.commented_news_articles.first).to eq(news_article)
      
      expect(news_article.comments.count).to eq(1)
      expect(news_article.comments.first).to eq(comment_for_article)
      
      expect(news_article.commenting_users.count).to eq(1)
      expect(news_article.commenting_users.first).to eq(user)
    end
    
    it 'should remove User Comment from NewsArticles' do
      user = FactoryBot.create(:user, country: @country, user_security_question: @user_security_question)
      news_article = FactoryBot.create(:news_article, country: @country)
      comment_for_article = FactoryBot.create(:comment, user: user, source: news_article)
      expect(user.comments.count).to eq(1)
      
      # Remove comment
      comment_for_article.destroy
      
      # Check that there no comments for exists objects
      expect(user.comments.count).to eq(0)
      expect(user.commented_news_articles.count).to eq(0)
      expect(news_article.comments.count).to eq(0)
      expect(news_article.commenting_users.count).to eq(0)
    end
  end
end
