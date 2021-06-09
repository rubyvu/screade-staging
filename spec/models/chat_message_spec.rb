require 'rails_helper'

RSpec.describe ChatMessage, type: :model do
  before :all do
    @country = Country.find_by(code: 'US') || FactoryBot.create(:country, code: 'US')
    @user_security_question = FactoryBot.create(:user_security_question)
    @user_owner = FactoryBot.create(:user, country: @country, user_security_question: @user_security_question)
    @chat = FactoryBot.build(:chat, owner: @user_owner)
    @chat_membership = FactoryBot.create(:chat_membership, chat: @chat, user: @user_owner)
  end
  
  it 'should have a valid factory' do
    expect(FactoryBot.build(:chat_message, user: @user_owner, chat: @chat, type: 'text', text: 'Test message 1')).to be_valid
  end
  
  context 'associations' do
    it { should belong_to(:chat) }
    it { should belong_to(:user) }
  end
  
  context 'validations' do
    context 'associations' do
      it { should validate_presence_of(:chat) }
      it { should validate_presence_of(:user) }
    end
    
    context 'fields' do
      it { should validate_presence_of(:type) }
      it { should validate_inclusion_of(:type).in_array(ChatMessage::TYPES_LIST) }
    end
  end
end
