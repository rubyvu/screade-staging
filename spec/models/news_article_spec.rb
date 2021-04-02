require 'rails_helper'

RSpec.describe NewsArticle, type: :model do
  before :all do
    @country = FactoryBot.build(:country)
  end
  
  it 'should have a valid factory' do
    expect(FactoryBot.build(:news_article, country: @country)).to be_valid
  end
  
  context 'associations' do
    it { should belong_to(:country) }
    it { should belong_to(:news_source).optional }
    it { should have_and_belong_to_many(:news_categories) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:commenting_users) }
    it { should have_many(:lits).dependent(:destroy) }
    it { should have_many(:liting_users) }
    it { should have_many(:views).dependent(:destroy) }
    it { should have_many(:viewing_users) }
    it { should have_many(:news_article_subscriptions).dependent(:destroy) }
    it { should have_many(:subscripted_news_categories) }
    it { should have_many(:subscripted_topics) }
  end
  
  context 'validations' do
    subject { FactoryBot.build(:news_article, country: @country) }
    
    context 'associations' do
      it { should validate_presence_of(:country) }
    end
    
    context 'fields' do
      it { should validate_presence_of(:title) }
      it { should validate_presence_of(:published_at) }
      it { should validate_uniqueness_of(:url) }
      it { should validate_presence_of(:url) }
    end
  end
end
