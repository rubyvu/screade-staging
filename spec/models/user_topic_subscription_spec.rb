require 'rails_helper'

RSpec.describe UserTopicSubscription, type: :model do
  before :all do
    @country = Country.find_by(code: 'US') || FactoryBot.create(:country, code: 'US')
    @user_security_question = FactoryBot.create(:user_security_question)
    @user = FactoryBot.create(:user, country: @country, user_security_question: @user_security_question)
    @news_category = FactoryBot.create(:news_category)
    @topic = FactoryBot.create(:topic, parent: @news_category)
  end
  
  it 'should have a valid factory' do
    expect(FactoryBot.build(:user_topic_subscription, user: @user, source: @news_category)).to be_valid
    expect(FactoryBot.build(:user_topic_subscription, user: @user, source:@topic)).to be_valid
  end
  
  context 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:source) }
  end
  
  context 'validations' do
    context 'NewsCategory' do
      subject { FactoryBot.build(:user_topic_subscription, user: @user, source: @news_category) }
      
      context 'fields' do
        it { should validate_presence_of(:source_id) }
        it { should validate_uniqueness_of(:source_id).scoped_to([:source_type, :user_id]) }
        it { should validate_presence_of(:source_type) }
        it { should validate_presence_of(:user_id) }
        it { should validate_uniqueness_of(:user_id).scoped_to([:source_type, :source_id]) }
      end
    end
    
    context 'Topic' do
      subject { FactoryBot.build(:user_topic_subscription, user: @user, source: @topic) }
      
      context 'fields' do
        it { should validate_presence_of(:source_id) }
        it { should validate_uniqueness_of(:source_id).scoped_to([:source_type, :user_id]) }
        it { should validate_presence_of(:source_type) }
        it { should validate_presence_of(:user_id) }
        it { should validate_uniqueness_of(:user_id).scoped_to([:source_type, :source_id]) }
      end
    end
  end
end
