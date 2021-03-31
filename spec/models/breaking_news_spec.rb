require 'rails_helper'

RSpec.describe BreakingNews, type: :model do
  it 'should have a valid factory' do
    expect(FactoryBot.build(:breaking_news)).to be_valid
  end
  
  context 'validations' do
    subject { FactoryBot.build(:breaking_news) }
    
    context 'fields' do
      it { should validate_presence_of(:title) }
    end
  end
  
  context 'callbacks' do
    context 'is_active should be unique' do
      after :each do
        BreakingNews.destroy_all
      end
      
      it 'should update all active records for new active record' do
        active_news_1 = FactoryBot.create(:breaking_news, is_active: true)
        inactive_news_1 = FactoryBot.create(:breaking_news)
        inactive_news_2 = FactoryBot.create(:breaking_news)
        
        expect(BreakingNews.count).to eq(3)
        expect(BreakingNews.where(is_active: true).count).to eq(1)
        expect(BreakingNews.find_by(is_active: true)).to eq(active_news_1)
        
        active_news_2 = FactoryBot.create(:breaking_news, is_active: true)
        expect(BreakingNews.count).to eq(4)
        expect(BreakingNews.where(is_active: true).count).to eq(1)
        expect(BreakingNews.find_by(is_active: true)).to eq(active_news_2)
      end
    end
  end
end
