require 'rails_helper'

RSpec.describe Chat, type: :model do
  before :all do
    @country = Country.find_by(code: 'US') || FactoryBot.create(:country, code: 'US')
    @user_security_question = FactoryBot.create(:user_security_question)
    @user_owner = FactoryBot.create(:user, country: @country, user_security_question: @user_security_question)
    @chat = FactoryBot.build(:chat, owner: @user_owner)
  end
  
  it 'should have a valid factory' do
    expect(@chat).to be_valid
  end
  
  context 'validations' do
    subject { @chat }
    
    context 'associations' do
      it { should have_many(:chat_memberships).dependent(:destroy) }
    end
  end
end
