require 'rails_helper'

RSpec.describe SharedRecord, type: :model do
  before :all do
    @country = Country.find_by(code: 'US') || FactoryBot.create(:country, code: 'US')
    @user_security_question = FactoryBot.create(:user_security_question)
    @user = FactoryBot.create(:user, country: @country, user_security_question: @user_security_question)
    @news_category = FactoryBot.create(:news_category)
    @topic = FactoryBot.create(:topic, parent: @news_category)
    @post = FactoryBot.build(:post, source: @topic, user: @user)
  end
  
  it 'should have a valid factory' do
    shared_record = FactoryBot.build(:shared_record, sender: @user, shareable: @post)
    expect(shared_record.valid?).to eq(true)
  end
  
  context 'associations' do
    it { is_expected.to belong_to(:sender).with_foreign_key(:sender_id).class_name('User').required }
    it { is_expected.to belong_to(:shareable).required }
    it { is_expected.to have_and_belong_to_many(:users) }
  end
  
  context 'validations' do
    context 'associations' do
      it { is_expected.to validate_presence_of(:shareable_type) }
      it { is_expected.to validate_inclusion_of(:shareable_type).in_array(SharedRecord::SHAREABLE_TYPES) }
    end
    
    context 'fields' do
    end
  end
end
