# == Schema Information
#
# Table name: views
#
#  id          :bigint           not null, primary key
#  source_type :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  source_id   :integer          not null
#  user_id     :integer          not null
#
# Indexes
#
#  index_views_on_source_id_and_source_type_and_user_id  (source_id,source_type,user_id) UNIQUE
#
require 'rails_helper'

RSpec.describe View, type: :model do
  before :all do
    @country = Country.find_by(code: 'US') || FactoryBot.create(:country, code: 'US')
    @user_security_question = FactoryBot.create(:user_security_question)
    @user = FactoryBot.create(:user, country: @country, user_security_question: @user_security_question)
    @news_article = FactoryBot.create(:news_article, country: @country)
  end
  
  it 'should have a valid factory' do
    expect(FactoryBot.build(:view, user: @user, source: @news_article)).to be_valid
  end
  
  context 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:source) }
  end
  
  context 'validations' do
    subject { FactoryBot.build(:view, user: @user, source: @news_article) }
    
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
    
    it 'should set User View to NewsArticles' do
      user = FactoryBot.create(:user, country: @country, user_security_question: @user_security_question)
      news_article = FactoryBot.create(:news_article, country: @country)
      
      # Check that there no views for new objects
      expect(user.views.count).to eq(0)
      expect(user.viewed_news_articles.count).to eq(0)
      expect(news_article.views.count).to eq(0)
      expect(news_article.viewing_users.count).to eq(0)
      
      view_for_article = FactoryBot.create(:view, user: user, source: news_article)
      
      # Check that all associations between User, View and NewsArticle are created
      expect(user.views.count).to eq(1)
      expect(user.views.first).to eq(view_for_article)
      
      expect(user.viewed_news_articles.count).to eq(1)
      expect(user.viewed_news_articles.first).to eq(news_article)
      
      expect(news_article.views.count).to eq(1)
      expect(news_article.views.first).to eq(view_for_article)
      
      expect(news_article.viewing_users.count).to eq(1)
      expect(news_article.viewing_users.first).to eq(user)
    end
    
    it 'should remove User View from NewsArticles' do
      user = FactoryBot.create(:user, country: @country, user_security_question: @user_security_question)
      news_article = FactoryBot.create(:news_article, country: @country)
      view_for_article = FactoryBot.create(:view, user: user, source: news_article)
      expect(user.views.count).to eq(1)
      
      # Remove view
      view_for_article.destroy
      
      # Check that there now views for exists objects
      expect(user.views.count).to eq(0)
      expect(user.viewed_news_articles.count).to eq(0)
      expect(news_article.views.count).to eq(0)
      expect(news_article.viewing_users.count).to eq(0)
    end
  end
end
