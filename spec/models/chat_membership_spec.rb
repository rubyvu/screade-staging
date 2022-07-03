# == Schema Information
#
# Table name: chat_memberships
#
#  id                    :bigint           not null, primary key
#  is_mute               :boolean          default(FALSE), not null
#  role                  :string           default("user"), not null
#  unread_messages_count :integer          default(0), not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  chat_id               :integer          not null
#  user_id               :integer          not null
#
# Indexes
#
#  index_chat_memberships_on_chat_id  (chat_id)
#  index_chat_memberships_on_user_id  (user_id)
#
require 'rails_helper'

RSpec.describe ChatMembership, type: :model do
  before :all do
    @country = Country.find_by(code: 'US') || FactoryBot.create(:country, code: 'US')
    @user_security_question = FactoryBot.create(:user_security_question)
    @user_owner = FactoryBot.create(:user, country: @country, user_security_question: @user_security_question)
    @user2 = FactoryBot.create(:user, country: @country, user_security_question: @user_security_question)
    @user_default = FactoryBot.create(:user, country: @country, user_security_question: @user_security_question)
    @chat = FactoryBot.create(:chat, owner: @user_owner)
    @chat_membership = FactoryBot.build(:chat_membership, chat: @chat, user: @user_owner)
  end
  
  it 'should have a valid factory' do
    expect(@chat_membership.valid?).to eq(true)
  end
  
  context 'associations' do
    it { is_expected.to belong_to(:chat).required }
    it { is_expected.to belong_to(:user).required }
  end
  
  context 'validations' do
    subject { FactoryBot.build(:chat_membership, chat: @chat, user: @user2) }
    
    context 'associations' do
      it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:chat_id) }
    end
    
    context 'fields' do
      it { is_expected.to validate_presence_of(:role) }
      it { is_expected.to validate_inclusion_of(:role).in_array(ChatMembership::ROLES_LIST) }
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
