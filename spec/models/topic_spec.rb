require 'rails_helper'

RSpec.describe Topic, type: :model do
  before :all do
    @news_category = FactoryBot.create(:news_category)
    @topic = FactoryBot.create(:topic, parent: @news_category)
    @sub_topic = FactoryBot.create(:topic, parent: @topic)
    @sub_sub_topic = FactoryBot.create(:topic, parent: @sub_topic)
  end
  
  it 'should have a valid factory' do
    expect(@topic.present?).to eq(true)
    expect(@topic.parent).to eq(@news_category)
    
    expect(@sub_topic.present?).to eq(true)
    expect(@sub_topic.parent).to eq(@topic)
    
    expect(@sub_sub_topic.present?).to eq(true)
    expect(@sub_sub_topic.parent).to eq(@sub_topic)
  end
  
  context 'associations' do
    it { should have_many(:sub_topics).dependent(:destroy) }
  end
  
  context 'validations' do
    # subject { FactoryBot.build(:news_category) }
    
    context 'associations' do
    end
    
    context 'fields' do
      # it { should validate_uniqueness_of(:title).case_insensitive }
      # it { should validate_presence_of(:title) }
    end
  end
end
