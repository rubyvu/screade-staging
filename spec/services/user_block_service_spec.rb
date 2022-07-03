require 'rails_helper'

RSpec.describe UserBlockService do
  before :all do
    country = Country.first || FactoryBot.create(:country)
    user_security_question = FactoryBot.create(:user_security_question)
    
    @user1 = FactoryBot.create(:user, country: country, user_security_question: user_security_question)
    @user2 = FactoryBot.create(:user, country: country, user_security_question: user_security_question)
    @user3 = FactoryBot.create(:user, country: country, user_security_question: user_security_question)
  end
  
  describe '#remove_from_squad' do
    it 'is expected to decline all SquadRequests' do
      user_block = FactoryBot.create(:user_block, blocker: @user1, blocked: @user2)
      squad_request1 = FactoryBot.create(:squad_request, receiver: @user1, requestor: @user2, accepted_at: DateTime.current)
      squad_request2 = FactoryBot.create(:squad_request, receiver: @user2, requestor: @user1, accepted_at: DateTime.current)
      
      UserBlockService.new(user_block).remove_from_squad
      
      squad_request1.reload
      expect(squad_request1.accepted_at).to eq(nil)
      expect(squad_request1.declined_at).not_to eq(nil)
      
      squad_request2.reload
      expect(squad_request2.accepted_at).to eq(nil)
      expect(squad_request2.declined_at).not_to eq(nil)
    end
  end
  
  describe '#remove_one_on_one_chats' do
    before :all do
      @chat123 = Chat.new(owner: @user1)
      @chat123.chat_memberships.build(user: @user1)
      @chat123.chat_memberships.build(user: @user2)
      @chat123.chat_memberships.build(user: @user3)
      @chat123.save!
      
      @chat13 = Chat.new(owner: @user1)
      @chat13.chat_memberships.build(user: @user1)
      @chat13.chat_memberships.build(user: @user3)
      @chat13.save!
    end
    
    context 'with existing Chat' do
      before :each do
        @chat12 = Chat.new(owner: @user1)
        @chat12.chat_memberships.build(user: @user1)
        @chat12.chat_memberships.build(user: @user2)
        @chat12.save!
        
        @chats_before_call = Chat.count
        
        user_block = FactoryBot.create(:user_block, blocker: @user1, blocked: @user2)
        UserBlockService.new(user_block).remove_one_on_one_chats
      end
      
      it 'is expected to delete existing 1-on-1 Chat' do
        expect(Chat.find_by(id: @chat12.id)).to eq(nil)
        expect(Chat.count).to eq(@chats_before_call - 1)
      end
      
      it 'is expected to NOT delete existing Group Chats' do
        expect(Chat.find_by(id: @chat123.id)).not_to eq(nil)
      end
      
      it 'is expected to NOT delete existing 1-on-1 Chats with other Users' do
        expect(Chat.find_by(id: @chat13.id)).not_to eq(nil)
      end
    end
    
    context 'WITHOUT existing Chat' do
      before :each do
        @chats_before_call = Chat.count
        
        user_block = FactoryBot.create(:user_block, blocker: @user1, blocked: @user2)
        UserBlockService.new(user_block).remove_one_on_one_chats
      end
      
      it 'is expected to NOT delete existing Chats' do
        expect(Chat.count).to eq(@chats_before_call)
      end
      
      it 'is expected to NOT delete existing Group Chats' do
        expect(Chat.find_by(id: @chat123.id)).not_to eq(nil)
      end
      
      it 'is expected to NOT delete existing 1-on-1 Chats with other Users' do
        expect(Chat.find_by(id: @chat13.id)).not_to eq(nil)
      end
    end
  end
end
