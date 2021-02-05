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
      it { should validate_uniqueness_of(:source_id).scoped_to(:source_type) }
      it { should validate_presence_of(:source_type) }
    end
  end
end
