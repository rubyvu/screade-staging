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
    it { should have_many(:sub_topics).class_name('Topic').with_foreign_key(:parent_id).dependent(:destroy) }
    it { should belong_to(:parent) }
  end
  
  context 'validations' do
    context 'associations' do
    end
    
    context 'fields' do
      it { should validate_presence_of(:nesting_position) }
      it { should validate_numericality_of(:nesting_position).is_less_than_or_equal_to(2).only_integer }
      it { should validate_presence_of(:parent_id) }
      it { should validate_presence_of(:parent_type) }
      it { should validate_inclusion_of(:parent_type).in_array(Topic::PARENT_TYPES) }
    end
    
    context 'custom' do
      it 'should NOT assigned to itself' do
        topic = FactoryBot.create(:topic, parent: @news_category)
        
        topic.parent = topic
        expect(topic.valid?).to eq(false)
        expect(topic.errors.count).to eq(1)
        expect(topic.errors.full_messages.last).to eq('Topic cannot be assigned to itself')
      end
    end
  end
  
  context 'approval' do
    it 'should be created with is_approved false' do
      topic = FactoryBot.create(:topic, parent: @news_category)
      expect(topic.is_approved).to eq(false)
    end
    
    it 'should changed is_approved to true' do
      topic = FactoryBot.create(:topic, parent: @news_category)
      
      topic.is_approved = true
      expect(topic.valid?).to eq(true)
    end
  end
  
  context 'nesting' do
    it 'should NOT create object to SubSubTopic' do
      topic = FactoryBot.create(:topic, parent: @news_category)
      sub_topic = FactoryBot.create(:topic, parent: topic)
      sub_sub_topic = FactoryBot.create(:topic, parent: sub_topic)
      
      sub_sub_sub_topic = FactoryBot.build(:topic, parent: sub_sub_topic)
      expect(sub_sub_sub_topic.valid?).to eq(false)
      expect(sub_sub_sub_topic.errors.count).to eq(1)
      expect(sub_sub_sub_topic.errors.full_messages.last).to eq('Nesting position must be less than or equal to 2')
    end
    
    it 'should destroy all assigned children Topics on destroy' do
      topic = FactoryBot.create(:topic, parent: @news_category)
      sub_topic = FactoryBot.create(:topic, parent: topic)
      sub_sub_topic = FactoryBot.create(:topic, parent: sub_topic)
      
      topic.destroy
      expect(topic.destroyed?).to eq(true)
      expect(Topic.find_by(id: sub_topic.id).nil?).to eq(true)
      expect(Topic.find_by(id: sub_sub_topic.id).nil?).to eq(true)
    end
  end
end
