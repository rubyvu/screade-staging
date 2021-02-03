require 'rails_helper'

RSpec.describe Country, type: :model do
  it 'should have a valid factory' do
    expect(FactoryBot.build(:country)).to be_valid
  end
  
  context 'associations' do
    it { should have_many(:news_articles).class_name('NewsArticle') }
  end
  
  context 'validations' do
    subject { FactoryBot.build(:country) }
    
    context 'associations' do
    end
    
    context 'fields' do
      it { should validate_presence_of(:title) }
      it { should validate_uniqueness_of(:code).case_insensitive }
      it { should validate_presence_of(:code) }
    end
  end
end
