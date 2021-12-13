# == Schema Information
#
# Table name: chats
#
#  id           :bigint           not null, primary key
#  access_token :string           not null
#  name         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  owner_id     :integer          not null
#
# Indexes
#
#  index_chats_on_access_token  (access_token) UNIQUE
#  index_chats_on_owner_id      (owner_id)
#
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
