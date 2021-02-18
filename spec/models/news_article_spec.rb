require 'rails_helper'

RSpec.describe NewsArticle, type: :model do
  before :all do
    @country = FactoryBot.build(:country)
    @news_category = FactoryBot.build(:news_category)
  end
  
  it 'should have a valid factory' do
    expect(FactoryBot.build(:news_article, country: @country, news_category: @news_category)).to be_valid
  end
  
  context 'associations' do
    it { should belong_to(:country) }
    it { should belong_to(:news_category) }
  end
  
  context 'validations' do
    subject { FactoryBot.build(:news_article, country: @country, news_category: @news_category) }
    
    context 'associations' do
    end
    
    context 'fields' do
      it { should validate_presence_of(:title) }
      it { should validate_presence_of(:published_at) }
      it { should validate_uniqueness_of(:url) }
      it { should validate_presence_of(:url) }
    end
  end
end
