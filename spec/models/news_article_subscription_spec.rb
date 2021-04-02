require 'rails_helper'

RSpec.describe NewsArticleSubscription, type: :model do
  before :all do
    @country = Country.find_by(code: 'US') || FactoryBot.create(:country, code: 'US')
    @news_article = FactoryBot.create(:news_article, country: @country)
    @news_category = FactoryBot.create(:news_category)
    @topic = FactoryBot.create(:topic, parent: @news_category)
  end
  
  it 'should have a valid factory' do
    expect(FactoryBot.build(:news_article_subscription, news_article: @news_article, source: @news_category)).to be_valid
    expect(FactoryBot.build(:news_article_subscription, news_article: @news_article, source:@topic)).to be_valid
  end
  
  context 'associations' do
    it { should belong_to(:news_article) }
    it { should belong_to(:source) }
  end
  
  context 'validations' do
    context 'NewsCategory' do
      subject { FactoryBot.build(:news_article_subscription, news_article: @news_article, source: @news_category) }
      
      context 'fields' do
        it { should validate_presence_of(:source_id) }
        it { should validate_uniqueness_of(:source_id).scoped_to([:source_type, :news_article_id]) }
        it { should validate_presence_of(:source_type) }
        it { should validate_presence_of(:news_article_id) }
        it { should validate_uniqueness_of(:news_article_id).scoped_to([:source_type, :source_id]) }
      end
    end
    
    context 'Topic' do
      subject { FactoryBot.build(:news_article_subscription, news_article: @news_article, source: @topic) }
      
      context 'fields' do
        it { should validate_presence_of(:source_id) }
        it { should validate_uniqueness_of(:source_id).scoped_to([:source_type, :news_article_id]) }
        it { should validate_presence_of(:source_type) }
        it { should validate_presence_of(:news_article_id) }
        it { should validate_uniqueness_of(:news_article_id).scoped_to([:source_type, :source_id]) }
      end
    end
  end

end
