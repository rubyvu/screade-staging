require 'rails_helper'

RSpec.describe ChatMembership, type: :model do
  before :all do
    @country = Country.find_by(code: 'US') || FactoryBot.create(:country, code: 'US')
    @user_security_question = FactoryBot.create(:user_security_question)
    @user_owner = FactoryBot.create(:user, country: @country, user_security_question: @user_security_question)
    @user_default = FactoryBot.create(:user, country: @country, user_security_question: @user_security_question)
    @chat = FactoryBot.create(:chat, owner: @user_owner)
    @chat_membership = FactoryBot.create(:chat_membership, chat: @chat, user: @user_owner)
  end
  
  it 'should have a valid factory' do
    expect(@chat_membership).to be_valid
  end
  
  context 'associations' do
    it { should belong_to(:chat) }
    it { should belong_to(:user) }
  end
  
  context 'validations' do
    subject { @chat_membership }
    
    context 'associations' do
      it { should validate_presence_of(:chat) }
      it { should validate_presence_of(:user) }
      it { should validate_uniqueness_of(:user).scoped_to([:chat_id, :user_id]) }
    end
    
    context 'fields' do
      it { should validate_presence_of(:role) }
      it { should validate_inclusion_of(:role).in_array(ChatMembership::ROLES_LIST) }
    end
    
    context 'custom' do
      it 'should set owner role for first membership only' do
        chat = FactoryBot.create(:chat, owner: @user_owner)
        expect(chat.chat_memberships.count).to eq(0)
        chat_membership_1 = FactoryBot.create(:chat_membership, chat: chat, user: @user_owner)
        chat_membership_2 = FactoryBot.create(:chat_membership, chat: chat, user: @user_default)
        
        expect(chat.chat_memberships.count).to eq(2)
        expect(chat_membership_1.role).to eq('owner')
        expect(chat_membership_2.role).to eq('user')
      end
      
      it 'should remove User(owner) Membership if Chat have ony 1 User' do
        chat = FactoryBot.create(:chat, owner: @user_owner)
        expect(chat.chat_memberships.count).to eq(0)
        chat_membership_1 = FactoryBot.create(:chat_membership, chat: chat, user: @user_owner)
        
        expect(chat.chat_memberships.count).to eq(1)
        expect(chat_membership_1.role).to eq('owner')
        chat_membership_1.destroy
        
        expect(chat.chat_memberships.count).to eq(0)
      end
      
      it 'should NOT remove User(owner) membership if Chat have more than 1 User' do
        chat = FactoryBot.create(:chat, owner: @user_owner)
        expect(chat.chat_memberships.count).to eq(0)
        chat_membership_1 = FactoryBot.create(:chat_membership, chat: chat, user: @user_owner)
        chat_membership_2 = FactoryBot.create(:chat_membership, chat: chat, user: @user_default)
        
        expect(chat.chat_memberships.count).to eq(2)
        expect(chat_membership_1.role).to eq('owner')
        chat_membership_1.destroy
        
        expect(chat.chat_memberships.count).to eq(2)
      end
    end
  end
end
