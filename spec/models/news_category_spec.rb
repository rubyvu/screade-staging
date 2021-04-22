require 'rails_helper'

RSpec.describe NewsCategory, type: :model do
  it 'should have a valid factory' do
    expect(FactoryBot.build(:news_category)).to be_valid
  end
  
  context 'associations' do
    it { should have_and_belong_to_many(:news_articles)}
    it { should have_many(:topics).dependent(:destroy) }
    it { should have_many(:user_topic_subscriptions).dependent(:destroy) }
    it { should have_many(:subscripted_users) }
  end
  
  context 'validations' do
    subject { FactoryBot.build(:news_category) }
    
    context 'associations' do
    end
    
    context 'fields' do
      it { should validate_uniqueness_of(:title).case_insensitive }
      it { should validate_presence_of(:title) }
    end
  end
  
  context 'normalization' do
    it 'should downcase :title' do
      user = FactoryBot.build(:news_category ,title: '  hEalth ')
      expect(user.title).to eq('health')
    end
  end
end
