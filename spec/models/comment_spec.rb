# == Schema Information
#
# Table name: comments
#
#  id                :bigint           not null, primary key
#  detected_language :string
#  lits_count        :integer          default(0), not null
#  message           :text
#  source_type       :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  comment_id        :integer
#  source_id         :integer          not null
#  user_id           :integer          not null
#
# Indexes
#
#  index_comments_on_detected_language  (detected_language)
#  index_comments_on_source_id          (source_id)
#
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
    it { is_expected.to belong_to(:comment).optional }
    it { is_expected.to have_many(:replied_comments).class_name('Comment').with_foreign_key(:comment_id).dependent(:destroy) }
    it { is_expected.to have_many(:shared_records) }
    it { is_expected.to belong_to(:source) }
    it { is_expected.to have_many(:translations) }
    it { is_expected.to belong_to(:user) }
  end
  
  context 'validations' do
    subject { FactoryBot.build(:comment, user: @user, source: @news_article) }
    
    context 'associations' do
    end
    
    context 'fields' do
      it { is_expected.to validate_presence_of(:message) }
      it { is_expected.to validate_presence_of(:source_id) }
      it { is_expected.to validate_presence_of(:source_type) }
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
  
  context 'reply' do
    before :all do
      @country = Country.find_by(code: 'US') || FactoryBot.create(:country, code: 'US')
      @user_security_question = FactoryBot.create(:user_security_question)
    end
    
    it 'should set child Comment' do
      user = FactoryBot.create(:user, country: @country, user_security_question: @user_security_question)
      news_article = FactoryBot.create(:news_article, country: @country)
      
      # Check that there no comments for new objects
      expect(user.comments.count).to eq(0)
      expect(user.commented_news_articles.count).to eq(0)
      expect(news_article.comments.count).to eq(0)
      expect(news_article.commenting_users.count).to eq(0)
      
      comment_for_article = FactoryBot.create(:comment, user: user, source: news_article)
      reply_comment = FactoryBot.create(:comment, user: user, source: news_article, comment_id: comment_for_article.id)
      
      expect(user.comments.count).to eq(2)
      expect(user.commented_news_articles.count).to eq(2)
      expect(news_article.comments.count).to eq(2)
      expect(news_article.commenting_users.uniq.count).to eq(1)
    end
    
    it 'should NOT set child Comment for replied comment' do
      user = FactoryBot.create(:user, country: @country, user_security_question: @user_security_question)
      news_article = FactoryBot.create(:news_article, country: @country)
      
      # Check that there no comments for new objects
      expect(user.comments.count).to eq(0)
      expect(user.commented_news_articles.count).to eq(0)
      expect(news_article.comments.count).to eq(0)
      expect(news_article.commenting_users.count).to eq(0)
      
      comment_for_article = FactoryBot.create(:comment, user: user, source: news_article)
      reply_comment = FactoryBot.create(:comment, user: user, source: news_article, comment: comment_for_article)
      invalid_comment = FactoryBot.build(:comment, user: user, source: news_article, comment: reply_comment)
      
      expect(invalid_comment.valid?).to eq(false)
      expect(invalid_comment.errors.full_messages.first).to eq('You can create reply only from parent comment.')
    end
  end
  
  describe 'hooks' do
    it 'is expected to delete :message Translations if :message was changed' do
      comment = FactoryBot.create(:comment, user: @user, source: @news_article)
      language1 = Language.find_by(code: 'EN')
      language2 = Language.find_by(code: 'DE')
      message_translation1 = FactoryBot.create(:translation, language: language1, translatable: comment, field_name: 'message')
      message_translation2 = FactoryBot.create(:translation, language: language2, translatable: comment, field_name: 'message')
      
      expect(comment.translations.count).to eq(2)
      
      comment.update(message: Faker::Lorem.characters(number: 50))
      
      expect(comment.translations.count).to eq(0)
    end
  end
end
