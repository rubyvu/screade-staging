require 'rails_helper'

RSpec.describe BreakingNews, type: :model do
  before :all do
    @country = FactoryBot.build(:country)
  end
  
  it 'should have a valid factory' do
    expect(FactoryBot.build(:breaking_news, country: @country)).to be_valid
  end
  
  context 'associations' do
    it { should belong_to(:country) }
  end
  
  context 'validations' do
    subject { FactoryBot.build(:breaking_news, country: @country) }
    
    context 'associations' do
      it { should validate_presence_of(:country) }
    end
    
    context 'fields' do
      it { should validate_presence_of(:title) }
    end
  end
  
  context 'callbacks' do
    context 'is_active change in one country' do
      before :all do
        @usa_country = Country.find_by(code: 'us') || FactoryBot.create(:country, code: 'us')
      end
      
      after :each do
        BreakingNews.destroy_all
      end
      
      it 'should update all active records in country for new active record' do
        active_news_1 = FactoryBot.create(:breaking_news, country: @usa_country, is_active: true)
        inactive_news_1 = FactoryBot.create(:breaking_news, country: @usa_country)
        inactive_news_2 = FactoryBot.create(:breaking_news, country: @usa_country)
        
        expect(@usa_country.breaking_news.count).to eq(3)
        expect(@usa_country.breaking_news.where(is_active: true).count).to eq(1)
        expect(@usa_country.breaking_news.find_by(is_active: true)).to eq(active_news_1)
        
        active_news_2 = FactoryBot.create(:breaking_news, country: @usa_country, is_active: true)
        expect(@usa_country.breaking_news.count).to eq(4)
        expect(@usa_country.breaking_news.where(is_active: true).count).to eq(1)
        expect(@usa_country.breaking_news.find_by(is_active: true)).to eq(active_news_2)
      end
      
      it 'should update all active records in the country after exists record updating' do
        active_news_1 = FactoryBot.create(:breaking_news, country: @usa_country, is_active: true)
        inactive_news_1 = FactoryBot.create(:breaking_news, country: @usa_country)
        inactive_news_2 = FactoryBot.create(:breaking_news, country: @usa_country)
        inactive_news_3 = FactoryBot.create(:breaking_news, country: @usa_country)
        
        expect(@usa_country.breaking_news.count).to eq(4)
        expect(@usa_country.breaking_news.where(is_active: true).count).to eq(1)
        expect(@usa_country.breaking_news.find_by(is_active: true)).to eq(active_news_1)
        
        inactive_news_3.update(is_active: true)
        
        expect(@usa_country.breaking_news.count).to eq(4)
        expect(@usa_country.breaking_news.where(is_active: true).count).to eq(1)
        expect(@usa_country.breaking_news.find_by(is_active: true)).to eq(inactive_news_3)
      end
    end
    
    context 'is_active change out of country' do
      before :all do
        @usa_country = Country.find_by(code: 'us') || FactoryBot.create(:country, code: 'us')
        @ua_country = Country.find_by(code: 'ua') || FactoryBot.create(:country, code: 'ua')
      end
      
      after :each do
        BreakingNews.destroy_all
      end
      
      it 'should NOT update records out of current country' do
        active_news_usa = FactoryBot.create(:breaking_news, country: @usa_country, is_active: true)
        active_news_ua = FactoryBot.create(:breaking_news, country: @ua_country, is_active: true)
        inactive_news_ua = FactoryBot.create(:breaking_news, country: @ua_country)
        
        expect(@usa_country.breaking_news.count).to eq(1)
        expect(@ua_country.breaking_news.count).to eq(2)
        
        expect(active_news_usa.is_active).to eq(true)
        expect(active_news_ua.is_active).to eq(true)
        expect(inactive_news_ua.is_active).to eq(false)
        
        inactive_news_ua.update(is_active: true)
        
        expect(@usa_country.breaking_news.count).to eq(1)
        expect(@ua_country.breaking_news.count).to eq(2)
        
        expect(active_news_usa.reload.is_active).to eq(true)
        expect(active_news_ua.reload.is_active).to eq(false)
        expect(inactive_news_ua.reload.is_active).to eq(true)
      end
    end
  end
end
