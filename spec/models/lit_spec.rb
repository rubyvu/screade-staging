require 'rails_helper'

RSpec.describe Lit, type: :model do
  before :all do
    @country = Country.find_by(code: 'US') || FactoryBot.create(:country, code: 'US')
    @user_security_question = FactoryBot.create(:user_security_question)
    @user = FactoryBot.create(:user, country: @country, user_security_question: @user_security_question)
    @news_article = FactoryBot.create(:news_article, country: @country)
  end
  
  it 'should have a valid factory' do
    expect(FactoryBot.build(:lit, user: @user, source: @news_article)).to be_valid
  end
  
  context 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:source) }
  end
  
  context 'validations' do
    subject { FactoryBot.build(:lit, user: @user, source: @news_article) }
    
    context 'associations' do
    end
    
    context 'fields' do
      it { should validate_presence_of(:source_id) }
      it { should validate_uniqueness_of(:source_id).scoped_to([:source_type, :user_id]) }
      it { should validate_presence_of(:source_type) }
    end
  end
  
  context 'object' do
    before :all do
      @country = Country.find_by(code: 'US') || FactoryBot.create(:country, code: 'US')
      @user_security_question = FactoryBot.create(:user_security_question)
    end
    
    it 'should set User Lit to NewsArticles' do
      user = FactoryBot.create(:user, country: @country, user_security_question: @user_security_question)
      news_article = FactoryBot.create(:news_article, country: @country)
      
      # Check that there no lits for new objects
      expect(user.lits.count).to eq(0)
      expect(user.lited_news_articles.count).to eq(0)
      expect(news_article.lits.count).to eq(0)
      expect(news_article.liting_users.count).to eq(0)
      
      lit_for_article = FactoryBot.create(:lit, user: user, source: news_article)
      
      # Check that all associations between User, Lit and NewsArticle are created
      expect(user.lits.count).to eq(1)
      expect(user.lits.first).to eq(lit_for_article)
      
      expect(user.lited_news_articles.count).to eq(1)
      expect(user.lited_news_articles.first).to eq(news_article)
      
      expect(news_article.lits.count).to eq(1)
      expect(news_article.lits.first).to eq(lit_for_article)
      
      expect(news_article.liting_users.count).to eq(1)
      expect(news_article.liting_users.first).to eq(user)
    end
    
    it 'should remove User Lit from NewsArticles' do
      user = FactoryBot.create(:user, country: @country, user_security_question: @user_security_question)
      news_article = FactoryBot.create(:news_article, country: @country)
      lit_for_article = FactoryBot.create(:lit, user: user, source: news_article)
      expect(user.lits.count).to eq(1)
      
      # Remove lit
      lit_for_article.destroy
      
      # Check that there no lits for exists objects
      expect(user.lits.count).to eq(0)
      expect(user.lited_news_articles.count).to eq(0)
      expect(news_article.lits.count).to eq(0)
      expect(news_article.liting_users.count).to eq(0)
    end
  end
end
