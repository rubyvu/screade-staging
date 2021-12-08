require 'rails_helper'

RSpec.describe NewsArticle, type: :model do
  before :all do
    @country = FactoryBot.build(:country)
  end
  
  it 'should have a valid factory' do
    expect(FactoryBot.build(:news_article, country: @country)).to be_valid
  end
  
  context 'associations' do
    it { is_expected.to belong_to(:country) }
    it { is_expected.to belong_to(:news_source).optional }
    it { is_expected.to have_and_belong_to_many(:news_categories) }
    it { is_expected.to have_and_belong_to_many(:topics) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { is_expected.to have_many(:commenting_users) }
    it { is_expected.to have_many(:lits).dependent(:destroy) }
    it { is_expected.to have_many(:liting_users) }
    it { is_expected.to have_many(:shared_records) }
    it { is_expected.to have_many(:views).dependent(:destroy) }
    it { is_expected.to have_many(:viewing_users) }
  end
  
  context 'validations' do
    subject { FactoryBot.build(:news_article, country: @country) }
    
    context 'associations' do
      it { is_expected.to validate_presence_of(:country) }
    end
    
    context 'fields' do
      it { is_expected.to validate_presence_of(:title) }
      it { is_expected.to validate_presence_of(:published_at) }
      it { is_expected.to validate_uniqueness_of(:url) }
      it { is_expected.to validate_presence_of(:url) }
    end
  end
end
